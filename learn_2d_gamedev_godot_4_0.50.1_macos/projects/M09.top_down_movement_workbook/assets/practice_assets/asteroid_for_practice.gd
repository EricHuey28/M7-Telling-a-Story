extends AnimatableBody2D

@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _collision_shape_2d: CollisionShape2D = %CollisionShape2D

@export_range(0.1, 1.0) var scale_limit_down := 0.2
@export_range(1.0, 3.0) var scale_limit_up := 1.3

var _direction := Vector2.ONE
var _speed := 10.0
var _rotation_speed := 1.0


func _ready() -> void:
	var random_ratio := randf_range(scale_limit_down, scale_limit_up)
	_sprite_2d.scale = Vector2.ONE * random_ratio
	(_collision_shape_2d.shape as CircleShape2D).radius *= random_ratio

	var away_from_center := Vector2.ZERO.direction_to(global_position)
	_sprite_2d.rotation = away_from_center.angle() + randf_range(-PI * 0.5, PI * 0.5)

	_direction = Vector2.from_angle(_sprite_2d.rotation)
	_speed = randf_range(2.0, 25.0)
	_rotation_speed = randf_range(0.01, 0.15)


func _physics_process(delta: float) -> void:
	set_deferred("position", position + _direction * _speed * delta)
	_sprite_2d.rotation += _rotation_speed * delta
