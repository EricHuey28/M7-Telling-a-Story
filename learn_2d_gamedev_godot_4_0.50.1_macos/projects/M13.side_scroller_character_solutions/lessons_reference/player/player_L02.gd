extends CharacterBody2D

## How quickly the character builds up speed (in pixels / second²)
@export var acceleration := 700.0
## How quickly the character slows down (in pixels / second²)
@export var deceleration := 1400.0
## The character's maximum horizontal movement speed (in pixels / second)
@export var max_speed := 120.0
## Downward acceleration applied every frame due to gravity (in pixels / second²)
@export var jump_gravity := 1200.0

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D


func _physics_process(delta: float) -> void:
	#ANCHOR: direction_and_run
	var direction_x := signf(Input.get_axis("move_left", "move_right"))

	var is_moving := absf(direction_x) > 0.0
	if is_moving:
		velocity.x += direction_x * acceleration * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		#END: direction_and_run

		#ANCHOR: animation_run
		animated_sprite.flip_h = direction_x < 0.0
		animated_sprite.play("Run")
		#END: animation_run
	#ANCHOR: else_velocity
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		#END: else_velocity
		#ANCHOR: animation_idle
		animated_sprite.play("Idle")
		#END: animation_idle

	#ANCHOR: gravity
	velocity.y += jump_gravity * delta
	#END: gravity
	#ANCHOR: move_and_slide
	move_and_slide()
	#END: move_and_slide
