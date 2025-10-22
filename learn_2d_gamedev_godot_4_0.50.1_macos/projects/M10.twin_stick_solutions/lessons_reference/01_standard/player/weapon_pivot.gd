extends Node2D

var is_using_gamepad := false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventKey:
		is_using_gamepad = false
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		is_using_gamepad = true


#ANCHOR:_process_definition
func _process(_delta: float) -> void:
	#END:_process_definition
	var aim_direction := Vector2.ZERO
	if is_using_gamepad:
		aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	else:
		aim_direction = global_position.direction_to(get_global_mouse_position())
	if aim_direction.length() > 0.1:
		rotation = aim_direction.angle()

	#ANCHOR:z_index
	z_index = 3
	if aim_direction.y < 0.0:
		z_index = 1
		#END:z_index
