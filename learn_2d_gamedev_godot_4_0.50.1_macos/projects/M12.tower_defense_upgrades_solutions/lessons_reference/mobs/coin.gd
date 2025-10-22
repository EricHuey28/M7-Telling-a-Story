class_name Coin extends Area2D

var tween: Tween = null


func _ready() -> void:
	var random_angle := randf_range(0.0, 2.0 * PI)
	var jump_distance := randf_range(40.0, 80.0)
	var target_global_position := Vector2.from_angle(random_angle) * jump_distance + global_position

	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self, "global_position", target_global_position, 0.5
	)


func animate_to_ui() -> void:
	if tween != null:
		tween.kill()

	set_deferred("monitorable", false)
	var target_position := PlayerUI.get_coin_ui_position()

	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", target_position, 0.7)
	tween.finished.connect(func () -> void:
		PlayerUI.coins += 10
		queue_free()
	)
