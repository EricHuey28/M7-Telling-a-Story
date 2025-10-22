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
	_add_simple_check(tr("Direction vector matches simulated inputs"), _test_direction_vector_matches_simulated_inputs)
	_add_simple_check(tr("Ship moves with pressed direction keys"), _test_ship_moves_with_pressed_direction_keys)


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


func is_practice_direction_similar_to_expected_direction(frame_previous: FrameData, frame_current: FrameData) -> bool:
	var practice_direction_sign := frame_current.practice_direction.sign()
	# Just to be sure there's no race condition, we check the ship direction against both the previous and current frame expected direction. The first line should be the correct check.
	return (
		practice_direction_sign == frame_previous.correct_input_direction.sign() or
		practice_direction_sign == frame_current.correct_input_direction.sign()
	)


func is_position_change_aligned_with_direction(frame_previous: FrameData, frame_current: FrameData) -> bool:
	if frame_previous.correct_input_direction.is_equal_approx(Vector2.ZERO):
		return true

	var position_change_direction := (frame_current.practice_position - frame_previous.practice_position).normalized()
	var dot_product := frame_previous.correct_input_direction.normalized().dot(position_change_direction)
	return abs(dot_product - 1.0) < 0.1


func _test_direction_vector_matches_simulated_inputs() -> String:
	if not _is_sliding_window_pass(is_practice_direction_similar_to_expected_direction):
		return tr("The direction of the ship in the practice is not as expected. Please make sure that you are using the correct input actions when calling Input.get_axis(): move_left and move_right for the horizontal direction, and move_up and move_down for the vertical direction.")
	return ""


func _test_ship_moves_with_pressed_direction_keys() -> String:
	if not _is_sliding_window_pass(is_position_change_aligned_with_direction):
		return tr("The ship is not moving in the direction of the pressed keys. Please make sure that you are using the correct input actions when calling Input.get_axis(): move_left and move_right for the horizontal direction, and move_up and move_down for the vertical direction.")
	return ""
