extends "res://addons/gdpractice/tester/test.gd"

# Data structure for storing the bullet's position and delta time.
# We don't need the solution's data in this practice to check the requirements.
class FrameData:
	var practice_position: Vector2
	var practice_rotation: float
	var solution_position: Vector2
	var practice_velocity: Vector2
	var delta: float

	func _to_string() -> String:
		return "Practice: %s" % [practice_position]


func _setup_populate_test_space() -> void:
	await _connect_timed(1.0, get_tree().process_frame, _populate_test_space)


func _build_checks() -> void:
	_add_simple_check(tr("Bullet moves towards top right"), _test_bullet_moves_towards_top_right)
	_add_simple_check(tr("Bullet moves based on velocity and delta"), _test_bullet_moves_based_on_velocity_and_delta)
	_add_simple_check(tr("The bullet rotation matches the velocity vector"), _test_the_bullet_rotation_matches_the_velocity_vector)



func _populate_test_space() -> void:
	var data := FrameData.new()
	data.practice_position = _practice.position
	data.practice_rotation = _practice.rotation
	data.practice_velocity = _practice.velocity
	data.solution_position = _solution.position
	data.delta = get_process_delta_time()
	_test_space.append(data)


var DIRECTION_TOP_RIGHT := Vector2(1, -1).normalized()
const MAX_EXPECTED_ANGLE = PI / 8.0

# Calculates the dot product of the direction calculated from bullet's position difference between two frames and the top-right direction vector.
# If the two vectors align, their dot product will be 1.0 (or close to 1.0).
func is_moving_towards_top_right(frame_previous: FrameData, frame_current: FrameData) -> bool:
	var position_difference := frame_current.practice_position - frame_previous.practice_position
	var angle: float = position_difference.normalized().angle_to(DIRECTION_TOP_RIGHT)
	return not position_difference.is_equal_approx(Vector2.ZERO) and abs(angle) <= MAX_EXPECTED_ANGLE


# Calculates the distance between the bullet's current position and the position it should be at based on the velocity and delta.
func is_moving_based_on_velocity_and_delta(frame_previous: FrameData, frame_current: FrameData) -> bool:
	var expected_motion := frame_previous.practice_velocity * frame_previous.delta
	var position_difference := frame_current.practice_position - frame_previous.practice_position
	return position_difference.distance_to(expected_motion) < 1.0


func is_moving_based_on_velocity_but_not_delta(frame_previous: FrameData, frame_current: FrameData) -> bool:
	var velocity: Vector2 = _practice.velocity
	var position_difference := frame_current.practice_position - frame_previous.practice_position
	var calculated_velocity := position_difference / frame_previous.delta
	return calculated_velocity.distance_squared_to(velocity) > 1.0


func is_rotation_incorrect(_frame_previous: FrameData, frame_current: FrameData) -> bool:
	var expected_rotation := frame_current.practice_velocity.angle()
	return abs(frame_current.practice_rotation - expected_rotation) > 0.1



func _test_bullet_moves_towards_top_right() -> String:
	# Test the dot product of the bullet's position difference between two frames and the vector (1, -1) (top right)
	if not _is_sliding_window_pass(is_moving_towards_top_right):
		# Check if it's moving roughly toward the top right but not at the correct angle
		# The bullet is meant to be moving at a constant velocity so we can just check two frames
		if _test_space.size() >= 2:
			var frame_previous := _test_space[-2] as FrameData
			var frame_current := _test_space[-1] as FrameData
			var direction := frame_previous.practice_position.direction_to(frame_current.practice_position)
			print(direction)

			if not direction.is_equal_approx(Vector2.ZERO):
				var angle_to_top_right: float = direction.angle_to(DIRECTION_TOP_RIGHT)
				if abs(angle_to_top_right) > MAX_EXPECTED_ANGLE and abs(angle_to_top_right) < PI / 4.0:
					return (
						tr("The bullet is roughly moving towards the top right, but it's going a little too much toward the right or the top.") + "\n" +
						tr("Try adjusting the velocity to make it move more diagonally towards the top right, like the reference.")
					)

		return tr("The bullet is not moving towards the top right. Is your velocity variable set correctly? It should be a Vector2 with a positive X coordinate and a negative Y coordinate.")
	return ""


func _test_bullet_moves_based_on_velocity_and_delta() -> String:
	var message := ""

	if _is_sliding_window_pass(is_moving_based_on_velocity_but_not_delta):
		message = tr("The bullet position is changing based on the velocity vector but does not take delta into account.")
	elif not _is_sliding_window_pass(is_moving_based_on_velocity_and_delta):
		message = tr("The bullet position does not appear to be moving based on the multiplication of the velocity and delta.")

	if message != "":
		message += " " + tr("In the _process() function, you should add the velocity multiplied by delta to the position.")
	return message


func _test_the_bullet_rotation_matches_the_velocity_vector() -> String:
	var last_tested_frame := _test_space.back() as FrameData

	if is_equal_approx(last_tested_frame.practice_rotation, 0.0):
		return tr("The bullet rotation is at 0. Have you changed the rotation in the _process() function?")
	elif _is_sliding_window_pass(is_rotation_incorrect):
		return tr("The bullet rotation does not match the velocity vector. In the _process() function, you should assign the velocity's angle to the rotation of the sprite. You can call the angle() function on the velocity variable to get the angle.")
	return ""
