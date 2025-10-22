extends "res://addons/gdpractice/tester/test.gd"


const INPUTS_TO_TEST := [
	[&"move_left"],
	[&"move_right"],
	[&"move_up"],
	[&"move_down"],
	[&"move_left", &"move_up"],
	[&"move_right", &"move_down"],
	[&"move_right", &"move_up"],
	[&"move_left", &"move_down"],
]

class FrameData:
	var practice_direction: Vector2
	var practice_position: Vector2
	var practice_velocity: Vector2

	var correct_input_direction: Vector2


func _setup_state() -> void:
	if _practice.max_speed > 0.0:
		_solution.max_speed = _practice.max_speed


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

	var requirement := Requirement.new()
	requirement.description = tr("The direction property should be defined")
	requirement.checker = func check_direction_property_defined() -> String:
		if not "direction" in _practice:
			return (
				tr("The direction variable is not defined in the practice script. Did you remove the direction variable defined at the top of the script? Did you move it into the _process() function?") + "\n" +
				tr("If so, please move it back to the top of the script. Otherwise, the practice system will not be able to test your code.") + "\n" +
				tr("You can reset the practice in the dock if needed.")
			)
		return ""
	requirements.append(requirement)


func _build_checks() -> void:
	_add_simple_check(tr("Direction vector is never longer than 1"), _test_direction_vector_is_never_longer_than_1)
	_add_simple_check(tr("Velocity vector is never longer than max speed"), _test_velocity_vector_is_never_longer_than_max_speed)


func _populate_test_space() -> void:
	var data := FrameData.new()
	data.practice_direction = _practice.direction
	data.practice_position = _practice.position
	data.practice_velocity = _practice.velocity

	data.correct_input_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	_test_space.append(data)


func is_direction_vector_lower_or_equal_to_1(frame_previous: FrameData, frame_current: FrameData) -> bool:
	return frame_current.practice_direction.length() <= 1.01


func is_velocity_vector_less_or_equal_to_max_speed(frame_previous: FrameData, frame_current: FrameData) -> bool:
	# The multiplier is to give the test a little error margin
	return frame_current.practice_velocity.length() <= _practice.max_speed * 1.01


func _test_direction_vector_is_never_longer_than_1() -> String:
	if not _is_sliding_window_pass(is_direction_vector_lower_or_equal_to_1):
		return tr("We found a case where the length of the direction vector was greater than 1.0. Did you normalize the direction vector?")
	return ""


func _test_velocity_vector_is_never_longer_than_max_speed() -> String:
	if not _is_sliding_window_pass(is_velocity_vector_less_or_equal_to_max_speed):
		return tr("We found a case where the length of the velocity vector was greater than the max speed. Did you normalize the direction vector?")
	return ""
