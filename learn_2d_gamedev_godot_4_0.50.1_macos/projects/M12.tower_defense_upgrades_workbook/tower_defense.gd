extends Node2D

## Dictionary mapping cell coordinates to turret instances.
var _game_board: Dictionary[Vector2i, Turret] = {}

@onready var _roads: TileMapLayer = %Roads
@onready var _player_hurtbox: Area2D = %PlayerHurtbox


func _ready() -> void:
	#ANCHOR:lose_health
	_player_hurtbox.area_entered.connect(
		func (_other_area: Area2D) -> void:
			PlayerUI.health -= 1
	)
	#END:lose_health
	#ANCHOR:health_depleted
	PlayerUI.health_depleted.connect(
		func() -> void:
			get_tree().reload_current_scene.call_deferred()
			PlayerUI.health = 5
	)
	#END:health_depleted


func _unhandled_input(event: InputEvent) -> void:
	#ANCHOR: check_coordinates
	if event.is_action_pressed("left_mouse_click"):
		var cell_coordinates := _roads.local_to_map(get_global_mouse_position())
		#END: check_coordinates

		#ANCHOR: check_valid_cells
		#ANCHOR: M02B_L07_cell_contents
		var cell_contents := _roads.get_cell_source_id(cell_coordinates)
		var is_road_tile := cell_contents != -1
		#END: M02B_L07_cell_contents
		#ANCHOR: M02B_L07_is_road_tile
		if is_road_tile or _game_board.has(cell_coordinates):
			return
			#END: M02B_L07_is_road_tile
		#END: check_valid_cells

		#ANCHOR: call_place_turret
		_place_turret(cell_coordinates)
		#END: call_place_turret


func _place_turret(cell_coordinates: Vector2i) -> void:
	var turret_instance := Turret.new()
	add_child(turret_instance)
	turret_instance.global_position = _roads.map_to_local(cell_coordinates)

	_game_board[cell_coordinates] = turret_instance
