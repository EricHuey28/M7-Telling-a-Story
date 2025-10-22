extends Node2D

@export var loot: PackedScene

@onready var chest: Node2D = %Chest


func on_chest_opened() -> void:
	for i in range(3):
		add_child(loot.instantiate())
