extends Area2D


func _ready() -> void:
	area_entered.connect(func (other_area: Area2D) -> void:
		if other_area is Coin:
			other_area.animate_to_ui()
	)


func _physics_process(_delta: float) -> void:
	global_position = get_global_mouse_position()
