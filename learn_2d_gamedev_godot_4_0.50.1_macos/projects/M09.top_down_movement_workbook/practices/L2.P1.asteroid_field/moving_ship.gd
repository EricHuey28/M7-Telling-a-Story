extends CharacterBody2D

var max_speed := 600.0
# For this practice, we moved the direction vector outside the _physics_process() function.
# This allows the interactive practice to read its value and test if your code passes!
# You can access and change the direction variable inside the _physics_process() function as you did in the lesson.
var direction := Vector2(0, 0)


func _physics_process(_delta: float) -> void:
	# Set the direction from keyboard inputs here.
	direction = direction
	# Set the velocity.
	velocity = velocity
	# Move the ship by calling the appropriate function from the CharacterBody2D node.

	if velocity.length() > 0.0:
		rotation = velocity.angle()
