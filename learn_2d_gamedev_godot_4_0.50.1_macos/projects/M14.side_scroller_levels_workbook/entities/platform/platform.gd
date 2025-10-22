@tool
class_name Platform extends AnimatableBody2D

@export_range(32.0, 512.0, 16.0) var width := 128.0: set = set_width

@onready var _collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var _shape: RectangleShape2D = _collision_shape_2d.shape
@onready var _sprite: NinePatchRect = %Sprite


func _ready() -> void:
	set_width(width)


func set_width(value: float) -> void:
	width = value
	if not is_inside_tree():
		return
	_shape.size.x = width
	_sprite.position.x = -width / 2.0
	_sprite.size.x = width
