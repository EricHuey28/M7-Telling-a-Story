@tool
class_name JumpTrajectoryVisualizer extends Node2D

@onready var parent_character = get_parent()

@export var trajectory_color := Color("ffd500")
@export var peak_marker_color := Color("ffecc9")
@export var landing_marker_color := Color("ffecc9")

var _parabola_points := PackedVector2Array()
var _peak_position := Vector2.ZERO
var _landing_position := Vector2.ZERO


func _ready() -> void:
	if not Engine.is_editor_hint():
		hide()
		set_process(false)


func _process(delta: float) -> void:
	if not visible:
		return

	_update_curve()
	queue_redraw()


func _draw() -> void:
	if _parabola_points.size() < 2:
		return

	draw_polyline(_parabola_points, trajectory_color, 2.0)

	# Draw circle at the peak and landing points
	draw_circle(_peak_position, 4.0, peak_marker_color)
	draw_circle(_landing_position, 4.0, landing_marker_color)


func _update_curve() -> void:
	var points := PackedVector2Array()

	var current_position := Vector2.ZERO
	points.append(current_position)

	const DELTA := 1.0 / 60.0
	const MAX_SIMULATION_TIME := 3.0
	var time_elapsed := 0.0

	# We recalculate the jump parameters from the parent character
	var max_speed := calculate_max_speed(parent_character.jump_horizontal_distance, parent_character.jump_time_to_peak, parent_character.jump_time_to_descent)
	var jump_speed := calculate_jump_speed(parent_character.jump_height, parent_character.jump_time_to_peak)
	var jump_gravity := calculate_jump_gravity(parent_character.jump_height, parent_character.jump_time_to_peak)
	var fall_gravity := calculate_fall_gravity(parent_character.jump_height, parent_character.jump_time_to_descent)

	var velocity := Vector2(max_speed, jump_speed)

	while time_elapsed < MAX_SIMULATION_TIME:
		var current_gravity = jump_gravity if velocity.y < 0.0 else fall_gravity

		velocity.y += current_gravity * DELTA
		current_position += velocity * DELTA

		const POINTS_MIN_DISTANCE := 1.0
		# Stop when the character lands
		if current_position.y >= 0.0 and time_elapsed > 0.1:
			var previous_position := points[-1] if points.size() > 0 else Vector2.ZERO
			var t := -previous_position.y / (current_position.y - previous_position.y)
			current_position = previous_position.lerp(current_position, t)
			points.append(current_position)
			break

		if points.size() == 0 or current_position.distance_to(points[-1]) >= POINTS_MIN_DISTANCE:
			points.append(current_position)

		time_elapsed += DELTA

	_peak_position = Vector2.ZERO
	var lowest_y = 0.0
	for point in points:
		if point.y < lowest_y:
			lowest_y = point.y
			_peak_position = point
	_landing_position = points[-1] if points.size() > 0 else Vector2.ZERO
	_parabola_points = points


func calculate_max_speed(distance: float, time_to_peak: float, time_to_descent: float) -> float:
	return distance / (time_to_peak + time_to_descent)


func calculate_jump_speed(height: float, time_to_peak: float) -> float:
	return (-2.0 * height) / time_to_peak


func calculate_jump_gravity(height: float, time_to_peak: float) -> float:
	return (2.0 * height) / pow(time_to_peak, 2.0)


func calculate_fall_gravity(height: float, time_to_descent: float) -> float:
	return (2.0 * height) / pow(time_to_descent, 2.0)
