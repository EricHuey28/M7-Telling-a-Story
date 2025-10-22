extends Sprite2D

var boost_speed := 2800.0
var normal_speed := 1200.0

var max_speed := normal_speed
var velocity := Vector2(0, 0)
var steering_factor := 10.0


func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		get_node("Timer").start()

	var desired_velocity := max_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * steering_factor * delta
	position += velocity * delta

	# The modified code for juicing starts here
	if material != null:
		var _angle_difference := wrapf(rotation - velocity.angle(), -PI, PI)
		material.set_shader_parameter("rotation_x", _angle_difference * 200.0)

	if velocity.length() > 0.0:
		rotation = velocity.angle()


func _on_timer_timeout() -> void:
	max_speed = normal_speed
