extends Sprite2D

#ANCHOR:boost_speed
var boost_speed := 1500.0
#END:boost_speed
#ANCHOR:normal_speed
var normal_speed := 600.0
#END:normal_speed
#ANCHOR:max_speed_is_normal_speed
var max_speed := normal_speed
#END:max_speed_is_normal_speed
var velocity := Vector2(0, 0)

func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

#ANCHOR:boost_speed_increase
	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
#END:boost_speed_increase
#ANCHOR:boost_timer_start
		get_node("Timer").start()
#END:boost_timer_start

#ANCHOR:velocity_calculation
	velocity = direction * max_speed
#END:velocity_calculation
	position += velocity * delta

	if direction.length() > 0.0:
		rotation = velocity.angle()

#ANCHOR:_on_timer_timeout
func _on_timer_timeout() -> void:
	max_speed = normal_speed
#END:_on_timer_timeout
