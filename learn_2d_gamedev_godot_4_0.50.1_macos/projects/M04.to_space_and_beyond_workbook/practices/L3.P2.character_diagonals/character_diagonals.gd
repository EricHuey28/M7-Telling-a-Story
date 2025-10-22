extends Sprite2D

var max_speed := 600.0
var velocity := Vector2(0, 0)
# Once again, the direction variable is outside the _process() function so the
# practice testing code can read its value.
var direction := Vector2(0, 0)


func _process(delta: float) -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	# The character is way too fast, but only when moving diagonally!
	# Add code to prevent that.

	velocity = direction * max_speed
	position += velocity * delta
	if velocity.length() > 0.0:
		rotation = velocity.angle()
