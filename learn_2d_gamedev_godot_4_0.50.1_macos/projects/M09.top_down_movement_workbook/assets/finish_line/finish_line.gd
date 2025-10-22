## Draws a finish line. Can resize itself to fit any rectangular area.
##
## Instead of using a fixed image texture, this finish line uses a shader to
## draw the lines and text. That allows it to cover any desired area.[br]
## [br]
## [FinishLine] inherits [Area2D], but it already has a collision shape baked in.
## When resizing [FinishLine], the associated collision shape also resizes
## accordingly.[br][br]
##
## [FinishLine] also has a [method pop_confettis] method which pops
## confettis and congratulate the player.
@tool
@icon("finish_line.svg")
class_name FinishLine extends Area2D

## Emitted when the confettis finish popping.
signal confettis_finished

@onready var _collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var _visual: ColorRect = %Visual
@onready var _confettis_area: ConfettisArea = %ConfettisArea

## Width of the area to draw. Changing this value updates the visuals and the
## collision shape.
@export_range(128, 640, 64) var area_width := 128: set = set_area_width
## Height of the area to draw. Changing this value updates the visuals and the
## collision shape.
@export_range(128, 640, 64) var area_height := 128: set = set_area_height

@export_group("Confettis", "confettis_")
## Determines how many confettis get popped when calling [method pop_confettis].
@export var confettis_amount := 5
## Determines a radius within which random confetti emitters will spawn when
## calling [method pop_confettis].
@export var confettis_radius := 128.0
## Determines the timing between different confetti emitter popping when calling
## [method pop_confettis].
@export var confettis_pop_time_delay := 0.5


func _ready():
	_recalculate_shape()
	if Engine.is_editor_hint():
		return
	_confettis_area.finished.connect(func() -> void:
		confettis_finished.emit()
	)


func set_area_width(value : int) -> void:
	area_width = value
	_recalculate_shape()


func set_area_height(value : int) -> void:
	area_height = value
	_recalculate_shape()


## Runs anytime width or height change. Resize both the visuals and the collision
## shape to match the desired size.
func _recalculate_shape():
	# if the node hasn't been added to the tree, we will get errors. Skip the
	# method entirely.
	if !is_inside_tree():
		return
	var size := Vector2(area_width, area_height)
	var shape := _collision_shape_2d.shape as RectangleShape2D
	shape.size = size

	# Reset and center the position of the ColorRect
	_visual.position = Vector2(-size.x / 2.0, 0)
	var children_position := Vector2(0, size.y / 2.0)
	_collision_shape_2d.position = children_position
	_confettis_area.position = children_position
	# Resize the ColorRect
	_visual.size = size
	# Pass the parameters to the shader
	_visual.material.set_shader_parameter("shape_ratio", Vector2(size.x / size.y, 1.0) if size.x > size.y else Vector2(1.0, size.y / size.x))


## Pops confettis from the center of the finish line. Once all confettis have been
## popped, emits the [signal confettis_finished] signal.
func pop_confettis() -> void:
	_confettis_area.confettis_amount = confettis_amount
	_confettis_area.confettis_radius = confettis_radius
	_confettis_area.confettis_pop_time_delay = confettis_pop_time_delay
	_confettis_area.pop_confettis()
