extends CharacterBody2D

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var camera_2d: Camera2D = %Camera2D

## Closest possible value. Higher is closer
@export var max_zoom_factor := 1.0
## Farthest possible value. Lower is farther
@export var min_zoom_factor := 0.7
## Maximum speed attained by the ship
@export var max_speed := 1000.0

var direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.lerp(direction * max_speed, 0.05)
	sprite_2d.rotation = velocity.angle()
	move_and_slide()
	
	# widen camera zoom depending on speed
	var speed_fraction := velocity.length() / max_speed
	var zoom_fraction := lerpf(min_zoom_factor, max_zoom_factor, 1.0 - speed_fraction)
	camera_2d.zoom = camera_2d.zoom.lerp(Vector2.ONE * zoom_fraction, 0.2)
