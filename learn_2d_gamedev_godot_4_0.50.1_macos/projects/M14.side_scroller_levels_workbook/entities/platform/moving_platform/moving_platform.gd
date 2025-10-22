@tool
extends Platform

@export_category("Path")
## This is the Path2D node the platform follows. This must be set for the platform to function
@export var path: Path2D = null: set = set_path
## Whether to start at the end of the path instead of the beginning. Use this to
## make the platform move in the opposite direction and sync multiple platforms.[br]
## You can alternatively design a path that goes in the opposite direction, but
## this property is there for convenience.
@export var start_at_end := false
## Whether to move back and forth along the path or restart from the beginning.
## Use this to make the platform move in a loop if the path is a closed loop.
@export var back_and_forth := true

@export_group("Movement")
## How fast the platform moves along the path in pixels per second
@export var movement_speed := 16.0
## The type of easing to use for the movement animation (which is tween-based)
@export var tween_trans_type: Tween.TransitionType = Tween.TRANS_SINE
## How high the platform waves up and down as it moves along the path
@export var wave_height := 7.0

var curve_length := 1.0

var _tween: Tween = null

@onready var _right_wing: AnimatedSprite2D = %RightWing
@onready var _left_wing: AnimatedSprite2D = %LeftWing
@onready var _sparkling_particles: GPUParticles2D = %SparklingParticles


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if path == null:
		warnings.append("Path2D must be set for the platform to move.")
	return warnings


func set_path(value: Path2D) -> void:
	path = value
	update_configuration_warnings()
	if Engine.is_editor_hint():
		return

	if path == null or path.curve == null:
		return

	var start_offset := 1.0 if start_at_end else 0.0
	var end_offset := 0.0 if start_at_end else 1.0
	_interpolate_position(start_offset)
	curve_length = path.curve.get_baked_length()
	var duration := curve_length / movement_speed
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween().set_loops(0).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS).set_trans(tween_trans_type)

	_tween.tween_method(_interpolate_position, start_offset, end_offset, duration)
	if back_and_forth:
		_tween.tween_method(_interpolate_position, end_offset, start_offset, duration)


func set_width(value: float) -> void:
	super(value)
	if not is_inside_tree():
		return
	var half_width := (width / 2.0) - 1
	_right_wing.position.x = half_width
	_left_wing.position.x = -half_width
	_sparkling_particles.process_material.set("emission_box_extents:x", half_width)


func _interpolate_position(offset: float) -> void:
	var new_position := path.global_position + path.curve.sample_baked(offset * curve_length)
	new_position.y += sin(offset * TAU) * wave_height
	global_position = new_position
