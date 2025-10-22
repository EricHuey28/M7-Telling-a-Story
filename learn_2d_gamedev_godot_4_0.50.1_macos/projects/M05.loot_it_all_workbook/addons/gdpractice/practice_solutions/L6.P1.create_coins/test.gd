extends "res://addons/gdpractice/tester/test.gd"

var CoinScene: PackedScene = load("res://practices/L6.P1.create_coins/coin.tscn")

var coin: Area2D = CoinScene.instantiate()
var finished_moving_count := 0
var practice_coin_count := 0


func _setup_populate_test_space() -> void:
	var practice_coins = _practice.find_children("Coin*", "Node2D").filter(
			func(coin: Node2D) -> bool:
				return coin.visible
	)
	practice_coin_count = practice_coins.size()

	# Queue the ship moving to each coin in both the practice and solution scenes
	for current_scene_root in [_practice, _solution]:
		var ship = current_scene_root.find_child("Ship*")
		var coins = current_scene_root.find_children("Coin*", "Node2D")
		if coins.size() == 0:
			finished_moving_count += 1
			continue

		ship.set_target_position(coins.front().position)
		for index: int in coins.size():
			var coin: Node2D = coins[index]
			if index + 1 < coins.size():
				var next_coin_position: Vector2 = coins[index + 1].position
				coin.tree_exited.connect(func():
					ship.set_target_position(next_coin_position)
				)

		coins.back().tree_exited.connect(func(): finished_moving_count += 1)

	var elapsed_time := 0.0
	while finished_moving_count < 2:
		await get_tree().create_timer(0.5).timeout
		elapsed_time += 0.5

		if elapsed_time > 2.0:
			break

	add_child(coin)
	coin.position = -Vector2.ONE * 10_000
	coin.hide()


func _build_checks() -> void:

	var check_coin_instances := Check.new()
	check_coin_instances.description = tr("There are coins in the practice main scene")
	check_coin_instances.checker = func() -> String:
		if practice_coin_count == 0:
			return tr("There are no coins in your practice scene.") + tr("Did you add instances of the coin scene to the main practice scene?")
		return ""

	var check_script := Check.new()
	check_script.description = tr("The coin scene has the provided script attached")
	check_script.dependencies = [check_coin_instances]
	check_script.checker = func() -> String:
		if coin.get_script() == null:
			return (
				tr("The coin does not have a script attached.") +
				tr("Did you drag and drop the script to the Coin node?")
			)
		if coin.get_script().resource_path != "res://practices/L6.P1.create_coins/coin.gd":
			return (
				tr("The coin has the wrong script attached.") +
				tr("Did you drag and drop the coin.gd script to the Coin node?")
			)
		return ""

	var check_collision_shape := Check.new()
	check_collision_shape.description = tr("The coin has a collision shape node as a child")
	check_collision_shape.dependencies = [check_coin_instances]
	check_collision_shape.checker = func() -> String:
		var matches := coin.find_children("*", "CollisionShape2D")
		if matches.size() == 0:
			return (
				tr("The coin does not appear to have a CollisionShape2D node as a child.") +
			 	tr("Did you add a CollisionShape2D node to the Coin scene?")
			)
		return ""

	var check_circle_shape := Check.new()
	check_circle_shape.description = tr("The coin's collision shape node has a CircleShape2D")
	check_circle_shape.dependencies = [check_collision_shape]
	check_circle_shape.checker = func() -> String:
		var collision_shape: CollisionShape2D = coin.find_children("*", "CollisionShape2D").front()
		if collision_shape.shape == null:
			return (
				tr("The coin's CollisionShape2D node does not have a shape assigned.") +
				tr("Did you add a CircleShape2D to the CollisionShape2D node?")
			)
		if not collision_shape.shape is CircleShape2D:
			return (
				tr("The coin's CollisionShape2D node has the wrong shape type assigned: %s.") % [collision_shape.shape.get_class()] +
				tr("Did you add a CircleShape2D to the CollisionShape2D node?")
			)
		return ""

	var check_sprite_node := Check.new()
	check_sprite_node.description = tr("The coin has a Sprite2D node as a child")
	check_sprite_node.dependencies = [check_coin_instances]
	check_sprite_node.checker = func() -> String:
		var matches := coin.find_children("*", "Sprite2D")
		if matches.size() == 0:
			return tr("The coin does not appear to have a Sprite2D node as a child.") + tr("Did you add a Sprite2D node to the Coin scene?")
		return ""

	var check_sprite_texture := Check.new()
	check_sprite_texture.description = tr("The coin's Sprite2D node has the provided coin texture assigned")
	check_sprite_texture.dependencies = [check_sprite_node]
	check_sprite_texture.checker = func() -> String:
		var sprite: Sprite2D = coin.find_children("*", "Sprite2D").front()
		if sprite.texture == null:
			return (
				tr("The coin's Sprite2D node does not have a texture assigned.") +
				tr("Did you assign the coin texture to the Sprite2D node?")
			)
		var COIN_TEXTURE_PATH := "res://assets/practice_assets/coin.png"
		if sprite.texture.get_path() != COIN_TEXTURE_PATH:
			return (
				tr("The coin's Sprite2D node has the wrong texture assigned.") +
				tr("Did you forget to assign the coin texture found at %s to the Sprite2D node?" % [COIN_TEXTURE_PATH])
			)
		return ""

	checks = [check_coin_instances, check_script, check_collision_shape, check_circle_shape, check_sprite_node, check_sprite_texture]
