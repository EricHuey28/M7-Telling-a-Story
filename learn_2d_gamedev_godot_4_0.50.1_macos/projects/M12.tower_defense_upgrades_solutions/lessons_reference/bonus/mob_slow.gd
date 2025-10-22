extends Mob

func apply_slow(intensity := 0.25, duration := 1.0) -> void:
	_current_speed = speed * (1.0 - intensity)
	modulate = Color.DEEP_SKY_BLUE
	get_tree().create_timer(duration).timeout.connect(
		func () -> void:
			_current_speed = speed
			modulate = Color.WHITE
	)
