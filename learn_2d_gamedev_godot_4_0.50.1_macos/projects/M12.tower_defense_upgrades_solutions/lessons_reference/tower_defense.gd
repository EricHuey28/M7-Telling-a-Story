#ANCHOR:l2_head
extends Node2D

## Dictionary mapping cell coordinates to turret instances.
var _game_board: Dictionary[Vector2i, Turret_2] = {}

@onready var _roads: Roads = %Roads
@onready var _player_hurtbox: Area2D = %PlayerHurtbox
#END:l2_head


func _ready() -> void:
	#ANCHOR:l2_ready_hurtbox
	_player_hurtbox.area_entered.connect(
		func (_other_area: Area2D) -> void:
			PlayerUI.health -= 1
	)
	PlayerUI.health_depleted.connect(
		func() -> void:
			get_tree().reload_current_scene.call_deferred()
			PlayerUI.health = 5
	)
	#END:l2_ready_hurtbox
	#ANCHOR:l2_calculate_paths
	for current_child: Node in get_children():
		if current_child is MobSpawner_2:
			var path := _roads.find_path_to_target(current_child, _player_hurtbox)
			current_child.initialize_path(path)
			#END:l2_calculate_paths

	PlayerUI.coins = 1000


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		var cell_coordinates := _roads.local_to_map(get_global_mouse_position())

		var cell_contents := _roads.get_cell_source_id(cell_coordinates)
		var is_road_tile := cell_contents != -1
		#ANCHOR: L07_is_road_tile
		if is_road_tile:
			return
			#END: L07_is_road_tile

		#ANCHOR: L07_request_new_turret_call
		if not _game_board.has(cell_coordinates):
			_request_new_turret(cell_coordinates)
			#END: L07_request_new_turret_call
		#ANCHOR: L07_request_turret_upgrade_call
		else:
			_request_turret_upgrade(cell_coordinates)
			#END: L07_request_turret_upgrade_call


func _request_new_turret(cell_coordinates: Vector2i) -> void:
	#ANCHOR: L07_request_new_turret_head
	const TURRET_COST := 200
	if PlayerUI.coins < TURRET_COST:
		return

	PlayerUI.coins -= TURRET_COST
	var turret_instance := Turret_2.new()
	add_child(turret_instance)
	turret_instance.global_position = _roads.map_to_local(cell_coordinates)

	_game_board[cell_coordinates] = turret_instance
	#END: L07_request_new_turret_head
	#ANCHOR: L07_request_new_turret_spawn_star
	_spawn_stars(turret_instance.global_position)
	#END: L07_request_new_turret_spawn_star


func _request_turret_upgrade(cell_coordinates: Vector2i) -> void:
	#ANCHOR: L07_request_turret_upgrade_head
	var turret: Turret_2 = _game_board.get(cell_coordinates)
	var upgrade := UpgradeDatabase.get_upgrades_for_weapon(turret.weapon, turret.level)
	if upgrade != null and upgrade.cost <= PlayerUI.coins:
		PlayerUI.coins -= upgrade.cost
		upgrade.apply_to_turret(turret)
		#END: L07_request_turret_upgrade_head
		#ANCHOR: L07_request_turret_upgrade_spawn_star
		_spawn_stars(turret.global_position)
		#END: L07_request_turret_upgrade_spawn_star


func _spawn_stars(target_global_position: Vector2) -> void:
	var stars: GPUParticles2D = preload("turrets/upgrades/star_particles.tscn").instantiate()
	add_child(stars)
	stars.global_position = target_global_position
	stars.finished.connect(stars.queue_free)
	stars.restart()
