class_name DamageIndicator_2 extends Node2D

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _label: Label = %Label


func _ready() -> void:
	_animation_player.animation_finished.connect(
		func (_anim_name: String) -> void:
			queue_free()
	)
	position.x = randf_range(-32.0, 32.0)


func display_amount(amount: float) -> void:
	position.x += randf_range(-32.0, 32.0)
	_label.text = str(int(amount))
