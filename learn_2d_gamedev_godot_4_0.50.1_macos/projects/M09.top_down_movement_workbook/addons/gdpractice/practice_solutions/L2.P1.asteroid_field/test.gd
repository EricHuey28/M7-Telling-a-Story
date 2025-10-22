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


var practice_ship: CharacterBody2D = null
var solution_ship: CharacterBody2D = null

var practice_max_speed := 0.0

func _setup_state() -> void:
	if practice_ship.max_speed > 0.0:
		solution_ship.max_speed = practice_ship.max_speed


func _setup_populate_test_space() -> void:
	# Simulate pressing down actions for 0.3 seconds, then release them.
	# Tests the ship moving in 8 directions.
	# During that timeframe, each frame, we store the state of the character.
	for action_list in INPUTS_TO_TEST:
		for action in action_list:
			Input.action_press(action)
		await _connect_timed(0.3, get_tree().physics_frame, func _populate_test_space() -> void:
			var data := FrameData.new()
			practice_max_speed = practice_ship.max_speed
			data.practice_direction = practice_ship.direction
			data.practice_position = practice_ship.position
			data.practice_velocity = practice_ship.velocity
			data.correct_input_direction = solution_ship.direction
			_test_space.append(data))
		for action in action_list:
			Input.action_release(action)


func _build_requirements() -> void:
	practice_ship = _practice.get_node_or_null("CharacterBody2D")
	solution_ship = _practice.get_node("CharacterBody2D")
	_add_actions_requirement(Utils.flatten_unique(INPUTS_TO_TEST))
	var node_name := "CharacterBody2D"
	_add_callable_requirement(
		tr("There should be an '%s' node")%[node_name],
		func() -> String:
			if not practice_ship:
				return tr("There is no '%s' node. Did you remove it? It's required for the practice to work")%[node_name]
			return ""
	)


func _build_checks() -> void:
	_add_simple_check(tr("Direction vector matches simulated inputs"), _test_direction_vector_matches_simulated_inputs)
	_add_simple_check(tr("Ship moves with pressed direction keys"), _test_ship_moves_with_pressed_direction_keys)
	_add_simple_check(tr("The ship moves according to its max speed and direction"), _test_ship_moves_according_to_max_speed_and_direction)
	_add_simple_check(tr("The script uses move_and_slide()"), _test_ship_is_using_move_and_slide)


func is_practice_direction_similar_to_expected_direction(frame_previous: FrameData, frame_current: FrameData) -> bool:
	var practice_direction_sign := frame_current.practice_direction.sign()
	# Just to be sure there's no race condition, we check the ship direction against both the previous and current frame expected direction. The first line should be the correct check.
	return (
		practice_direction_sign.is_equal_approx(frame_previous.correct_input_direction.sign()) or
		practice_direction_sign.is_equal_approx(frame_current.correct_input_direction.sign())
	)


func is_position_change_aligned_with_direction(frame_previous: FrameData, frame_current: FrameData) -> bool:
	if frame_previous.correct_input_direction.is_equal_approx(Vector2.ZERO):
		return true

	var practice_direction := (frame_current.practice_position - frame_previous.practice_position).normalized()
	if practice_direction.is_equal_approx(Vector2.ZERO):
		return true

	var dot_product := frame_current.correct_input_direction.dot(practice_direction)
	var is_aligned: bool = abs(dot_product - 1.0) < 0.1
	return is_aligned


func _test_direction_vector_matches_simulated_inputs() -> String:
	if not _is_sliding_window_pass(is_practice_direction_similar_to_expected_direction):
		return tr("The direction of the ship in the practice is not as expected. Please make sure that you are using the correct input actions when calling Input.get_vector(): move_left, move_right, move_up, and move_down.")
	return ""


func _test_ship_moves_with_pressed_direction_keys() -> String:
	# If the position doesn't change, we can't check if the ship is moving in the correct direction.
	var consecutive_frames_without_position_change := 0
	for frame_data in _test_space:
		if consecutive_frames_without_position_change > 10:
			return tr("The ship is not moving. Please make sure that you are setting the velocity of the ship and calculating the input direction.")
		if frame_data.practice_position.is_equal_approx(_test_space[0].practice_position):
			consecutive_frames_without_position_change += 1
		else:
			consecutive_frames_without_position_change = 0

	if not _is_sliding_window_pass(is_position_change_aligned_with_direction):
		return tr("The ship is not moving in the direction of the pressed keys. Please make sure that you are using the correct input actions when calling Input.get_vector()")
	return ""


func _test_ship_is_using_move_and_slide() -> String:
	var ship_script := _preprocess_practice_code(practice_ship.get_script())
	for line: String in ship_script:
		if "move_and_slide" in line:
			return ""
	return tr("The ship is not using the move_and_slide() method. Please make sure that you are using the correct method to move the ship.")


func _test_ship_moves_according_to_max_speed_and_direction() -> String:
	for frame_data: FrameData in _test_space:
		var expected_velocity := frame_data.correct_input_direction * practice_max_speed
		var speed := frame_data.practice_velocity.length()
		if speed < expected_velocity.length() - 0.1:
			return tr("The ship is not moving as fast as expected given its max_speed property. Did you multiply the direction by the max_speed variable?")

		var can_calculate_dot := frame_data.practice_velocity.length() > 0.0 and expected_velocity.length() > 0.0
		if can_calculate_dot and frame_data.practice_velocity.dot(expected_velocity) < 0.9:
			return tr("The ship is not moving in the correct direction. Did you use the direction variable to set the velocity of the ship?")
		if frame_data.practice_velocity.distance_to(expected_velocity) > 0.1:
			return tr("The ship is not moving according to its max speed and direction. Please make sure that you are setting the velocity of the ship correctly.")
	return ""
