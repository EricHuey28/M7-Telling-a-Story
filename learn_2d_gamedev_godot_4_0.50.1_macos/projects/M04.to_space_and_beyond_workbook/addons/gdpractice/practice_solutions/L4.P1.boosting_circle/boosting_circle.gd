extends Sprite2D

var boost_speed := 1200.0
var normal_speed := 600.0

var max_speed := normal_speed
var velocity := Vector2(0, 0)


func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	if Input.is_action_just_pressed("boost"):
		# Replace the pass keyword with the code to change the max_speed, get the timer node, and start it.
		max_speed = boost_speed # pass
		get_node("Timer").start() #

	velocity = direction * max_speed
	position += velocity * delta
	if direction.length() > 0.0:
		rotation = velocity.angle()


func _on_timer_timeout() -> void:
	max_speed = normal_speed #pass
