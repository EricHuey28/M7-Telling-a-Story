class_name Rock extends CharacterBody2D

func _physics_process(delta: float) -> void:
	if not is_on_floor(): 
		velocity.y += get_gravity().y * delta
	velocity.x = move_toward(velocity.x, 0.0, 200.0 * delta)
	move_and_slide()
