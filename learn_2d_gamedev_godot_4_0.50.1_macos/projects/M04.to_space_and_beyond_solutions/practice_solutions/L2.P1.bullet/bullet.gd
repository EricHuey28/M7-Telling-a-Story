extends Sprite2D

# Change the bullet's velocity to move towards the top right.
var velocity := Vector2(500, -500)#var velocity := Vector2(500, 0)

# Complete the process function to make the bullet move based on the velocity
# vector. Also, rotate the bullet to match the velocity vector's angle.
func _process(delta: float) -> void:
	position += velocity * delta # pass
	rotation = velocity.angle() #
