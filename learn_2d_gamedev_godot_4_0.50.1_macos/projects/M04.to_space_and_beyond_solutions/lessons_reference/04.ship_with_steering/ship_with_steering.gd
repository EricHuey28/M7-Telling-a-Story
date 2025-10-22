extends Sprite2D

var boost_speed := 1500.0
var normal_speed := 600.0

var max_speed := normal_speed
var velocity := Vector2(0, 0)
#ANCHOR:steering_factor
var steering_factor := 10.0
#END:steering_factor


# ANCHOR: process
func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		get_node("Timer").start()

#ANCHOR:desired_velocity
	var desired_velocity := max_speed * direction
#END:desired_velocity
#ANCHOR:steering_vector
	var steering_vector := desired_velocity - velocity
#END:steering_vector
#ANCHOR:velocity
	velocity += steering_vector * steering_factor * delta
#END:velocity
	position += velocity * delta

	if direction.length() > 0.0:
		rotation = velocity.angle()
# END: process


func _on_timer_timeout() -> void:
	max_speed = normal_speed
