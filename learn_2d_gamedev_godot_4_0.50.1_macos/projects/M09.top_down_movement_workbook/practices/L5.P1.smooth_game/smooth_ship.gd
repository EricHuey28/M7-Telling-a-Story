extends CharacterBody2D

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var collision_shape_2d = %CollisionShape2D

var max_speed := 800.0
var acceleration := 500.0
var deceleration := 500.0
var rotation_speed := 3.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var is_moving := direction.length() > 0.0

	if is_moving:
		var desired_velocity := direction * max_speed
		# Make the velocity progress toward the desired state over time.
		velocity = desired_velocity
	else:
		# Make the velocity go down to zero over time.
		velocity = Vector2.ZERO

	if direction.length() > 0:
		# Make sure to make the rotation progress towards the desired angle over time,
		# use the `orthogonal()` method, and don't forget to use `rotation_speed`!
		rotation = direction.angle()
	move_and_slide()
