#ANCHOR:l140_01
#ANCHOR:extends
extends Node2D
#END:extends

@onready var _teleporter: Area2D = %Teleporter
#END:l140_01
@onready var _end_menu: Control = %EndMenu
@onready var _invisible_walls: TileMapLayer = %InvisibleWalls


#ANCHOR:l140_02
func _ready() -> void:
	_teleporter.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			_end_menu.open()
	)
	#END:l140_02

	_invisible_walls.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		var window := get_window()
		if window.mode == Window.MODE_FULLSCREEN:
			window.mode = Window.MODE_WINDOWED
		else:
			window.mode = Window.MODE_FULLSCREEN
