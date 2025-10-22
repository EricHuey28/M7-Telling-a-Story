extends Control

signal health_depleted

var health := 5: set = set_health

@onready var _heart_h_box_container: HBoxContainer = %HBoxContainer


func _ready() -> void:
	set_health(health)


func set_health(new_health: int) -> void:
	#ANCHOR:health_display
	health = clampi(new_health, 0, 5)
	for child in _heart_h_box_container.get_children():
		child.visible = health > child.get_index()
	#END:health_display

	#ANCHOR:health_depletes
	if health == 0:
		health_depleted.emit()
		#END:health_depletes
