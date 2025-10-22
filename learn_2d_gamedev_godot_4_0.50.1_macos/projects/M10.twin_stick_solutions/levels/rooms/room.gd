extends Node2D

@onready var _invisible_walls: TileMapLayer = %InvisibleWalls


func _ready() -> void:
	_invisible_walls.hide()
