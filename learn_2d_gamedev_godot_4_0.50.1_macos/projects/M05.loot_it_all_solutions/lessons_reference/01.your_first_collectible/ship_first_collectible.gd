extends Area2D


var max_speed := 1200.0
var velocity := Vector2(0, 0)
var steering_factor := 3.0


func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	var desired_velocity := max_speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * steering_factor * delta
#ANCHOR: position_and_rotation
	position += velocity * delta

	if velocity.length() > 0.0:
#ANCHOR: rotation_only
		rotation = velocity.angle()
#END: rotation_only
#END: position_and_rotation
