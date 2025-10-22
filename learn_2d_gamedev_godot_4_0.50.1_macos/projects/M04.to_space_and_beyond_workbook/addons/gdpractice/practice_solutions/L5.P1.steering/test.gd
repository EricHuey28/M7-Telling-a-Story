extends "res://addons/gdpractice/tester/test.gd"


const INPUTS_TO_TEST := [
	[&"move_right"],
	[&"move_right", &"move_up"],
	[&"move_up"],
	[&"move_left", &"move_up"],
	[&"move_left"],
	[&"move_left", &"move_down"],
	[&"move_down"],
	[&"move_right", &"move_down"],
]

# For steering we compare the position and velocity of the practice and solution.
class FrameData:
	var practice_position: Vector2
	var practice_velocity: Vector2

	var solution_position: Vector2
	var solution_velocity: Vector2

	var input_direction: Vector2


func _setup_state() -> void:
	if _practice.max_speed > 0.0:
		_solution.max_speed = _practice.max_speed
	assert(_practice.steering_factor > 0.1 and _practice.steering_factor <= 15.0, tr("The steering factor should be between 0.1 and 15.0 for this practice to work. Please close the running scene by pressing F8, change the steering factor, and run the scene again."))
	_solution.steering_factor = _practice.steering_factor


func _setup_populate_test_space() -> void:
	# Simulate pressing down actions for 0.3 seconds, then release them.
	# Tests the ship moving in 8 directions.
	# During that timeframe, each frame, we store the state of the character.
	for action_list in INPUTS_TO_TEST:
		for action in action_list:
			Input.action_press(action)
		await _connect_timed(0.3, get_tree().process_frame, _populate_test_space)
		for action in action_list:
			Input.action_release(action)


func _build_requirements() -> void:
	_add_actions_requirement(Utils.flatten_unique(INPUTS_TO_TEST))


func _build_checks() -> void:
	_add_simple_check(tr("The ship velocity changes gradually"), _test_the_ship_velocity_changes_gradually)
	_add_simple_check(tr("The added steering uses steering factor and delta"), _test_the_added_steering_uses_steering_factor_and_delta)


func _populate_test_space() -> void:
	var data := FrameData.new()
	data.practice_position = _practice.position
	data.practice_velocity = _practice.velocity
	data.solution_position = _solution.position
	data.solution_velocity = _solution.velocity
	data.input_direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	_test_space.append(data)


# Note: moving this into the test function causes the value to constantly be reset to 0.
var _consecutive_frames_with_equal_velocity := 0

func _test_the_ship_velocity_changes_gradually() -> String:
	# If the calculated desired velocity and the actual velocity are equal for this amount of frames, then we can assume there's no steering.
	const EQUAL_FRAME_THRESHOLD := 30

	var is_velocity_changing_gradually := func (_frame_previous: FrameData, frame_current: FrameData) -> bool:
		var desired_velocity: Vector2 = frame_current.input_direction * _practice.max_speed
		if is_equal_approx(frame_current.practice_velocity.length(), 0.0) or desired_velocity.distance_to(frame_current.practice_velocity) < 2.0:
			_consecutive_frames_with_equal_velocity += 1
			if _consecutive_frames_with_equal_velocity >= EQUAL_FRAME_THRESHOLD:
				return false
		else:
			_consecutive_frames_with_equal_velocity = 0
		return true

	if not _is_sliding_window_pass(is_velocity_changing_gradually):
		return tr("The ship's velocity appears to be matching the desired velocity for too long. Instead, it should change gradually with steering. Did you add a fraction of the steering vector to the current velocity?")
	return ""


func _test_the_added_steering_uses_steering_factor_and_delta() -> String:
	var compare_velocity := func (_frame_previous: FrameData, frame_current: FrameData) -> bool:
		return frame_current.solution_velocity.distance_to(frame_current.practice_velocity) < 2.0
	
	if not _is_sliding_window_pass(compare_velocity):
		return tr("The velocity value in your version of the code doesn't match the velocity value in the solution. Did you add the steering vector to the current velocity? And did you multiply it by steering_factor and delta?")
	return ""
