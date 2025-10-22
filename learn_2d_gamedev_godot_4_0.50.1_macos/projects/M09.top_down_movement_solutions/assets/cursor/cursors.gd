@tool
extends CanvasLayer

@export_range(0.1, 2.0) var cursors_scale := 1.0: set = set_cursors_scale

@onready var _cursor_main: Area2D = %CursorMain
@onready var _collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var _cursor_secondary: Sprite2D = %CursorSecondary
@onready var _sprite: Sprite2D = %Sprite

var _shape: CircleShape2D = null

func _ready() -> void:
	_shape = _collision_shape_2d.shape as CircleShape2D

func set_cursors_scale(value: float) -> void:
	if not is_inside_tree():
		await ready
	cursors_scale = value
	_shape.radius = 200 * value
	var _scale = Vector2.ONE * value
	_sprite.scale = _scale
	_cursor_secondary.scale = _scale
