extends Area2D

var max_speed := 1200.0
var velocity := Vector2(0, 0)
var steering_factor := 10.0

func _process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var desired_velocity := max_speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * steering_factor * delta
	position += velocity * delta

	if velocity.length() > 0.0:
		rotation = velocity.angle()
