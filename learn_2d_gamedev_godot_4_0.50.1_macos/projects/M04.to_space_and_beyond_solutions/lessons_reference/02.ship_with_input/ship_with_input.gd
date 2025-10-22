#ANCHOR:progress_up_to_direction_calculation
extends Sprite2D

#ANCHOR:max_speed_definition
var max_speed := 600.0
#END:max_speed_definition
#ANCHOR:velocity_definition
var velocity := Vector2(0, 0)
#END:velocity_definition


#ANCHOR:_process
func _process(delta: float) -> void:
#ANCHOR:direction_definition
	var direction := Vector2(0, 0)
#END:direction_definition
#ANCHOR:direction_calculation
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
#END:direction_calculation
#END:progress_up_to_direction_calculation

	# If we don't do this and the player moves diagonally, they will move 40%
	# faster than normal.
#ANCHOR:direction_normalization
	if direction.length() > 1.0:
		direction = direction.normalized()
#END:direction_normalization

#ANCHOR:velocity_calculation
	velocity = direction * max_speed
#END:velocity_calculation
#ANCHOR:position_calculation
	position += velocity * delta
#END:position_calculation
#END:_process
#ANCHOR:rotation_calculation
	if direction.length() > 0.0:
		rotation = velocity.angle()
#END:rotation_calculation
