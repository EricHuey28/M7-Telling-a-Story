class_name DamageIndicator extends Node2D

@onready var _label: Label = %Label


func display_amount(amount: int) -> void:
	position.x += randf_range(-32.0, 32.0)
	_label.text = str(amount)
