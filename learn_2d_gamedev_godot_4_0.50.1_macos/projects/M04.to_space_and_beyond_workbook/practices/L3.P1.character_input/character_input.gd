extends Sprite2D

var max_speed := 600.0
var velocity := Vector2(0, 0)
# For this practice, we moved the direction vector outside the _process() function.
# This allows the interactive practice to read its value and test if your code passes!
# You can access and change the direction variable inside the _process() function as you did in the lesson.
var direction := Vector2(0, 0)

func _process(delta: float) -> void:
	# The direction is always equal to Vector2(0, 0)! Add code to remedy that.

	velocity = direction * max_speed
	position += velocity * delta
	if velocity.length() > 0.0:
		rotation = velocity.angle()
