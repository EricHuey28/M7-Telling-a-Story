extends "res://addons/gdpractice/tester/test.gd"

var CoinScene: PackedScene = load("res://practices/L6.P2.coins_and_energy_packs/coin.tscn")
var EnergyPackScene: PackedScene = load("res://practices/L6.P2.coins_and_energy_packs/energy_pack.tscn")

var coin: Area2D = CoinScene.instantiate()
var energy_pack: Area2D = EnergyPackScene.instantiate()
var _at_least_one_coin_is_in_correct_group := false
var _at_least_one_energy_pack_is_in_correct_group := false


var finished_moving_count := 0

func _setup_populate_test_space() -> void:
	# Queue the ship moving to each coin in both the practice and solution scenes
	for current_scene_root in [_practice, _solution]:
		var ship = current_scene_root.find_child("Ship*")
		var coins = current_scene_root.find_children("Coin*", "Node2D")
		_at_least_one_coin_is_in_correct_group = coins.any(func(item: Node2D) -> bool:
				return item.is_in_group("coin")
		)
		_at_least_one_energy_pack_is_in_correct_group = coins.any(func(item: Node2D) -> bool:
				return item.is_in_group("energy")
		)

		var energy_packs = current_scene_root.find_children("EnergyPack*", "Node2D")

		var target_nodes: Array = coins + energy_packs

		target_nodes.sort_custom(func (a: Node2D, b: Node2D):
			return a.get_index() < b.get_index()
		)

		if target_nodes.size() == 0:
			finished_moving_count += 1
			continue

		ship.set_target_position(target_nodes.front().position)
		for index: int in target_nodes.size():
			var coin: Node2D = target_nodes[index]
			if index + 1 < target_nodes.size():
				coin.tree_exited.connect(func():
					ship.set_target_position(target_nodes[index + 1].position)
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

	add_child(energy_pack)
	energy_pack.position = -Vector2.ONE * 20_000
	energy_pack.hide()


func _build_checks() -> void:
	var ship: Area2D = _practice.find_child("Ship*")
	ship = ship.duplicate()
	ship.position = Vector2(100000, 100000)
	add_child(ship)
	var ship_coins_count: Label = ship.find_child("CoinsCount")
	var ship_energy_bar: ProgressBar = ship.find_child("EnergyBar")

	var check_coin_group := Check.new()
	check_coin_group.description = tr("The coin scene root node has the 'coin' group")
	check_coin_group.checker = func() -> String:
		if not coin.is_in_group("coin"):
			if _at_least_one_coin_is_in_correct_group:
				return tr("You used the 'coin' group, but not in the coin scene. Make sure you apply the group to the coin scene.")
			return tr("The coin scene root node should be in the 'coin' group.")
		return ""

	var check_energy_pack_group := Check.new()
	check_energy_pack_group.description = tr("The energy pack scene root node has the 'energy' group")
	check_energy_pack_group.checker = func() -> String:
		if not energy_pack.is_in_group("energy"):
			if _at_least_one_energy_pack_is_in_correct_group:
				return tr("You used the 'energy' group, but not in the energy pack scene. Make sure you apply the group to the energy pack scene.")
			return tr("The energy pack scene root node should be in the 'energy' group.")
		return ""


	var ship_gains_coins := Check.new()
	ship_gains_coins.description = tr("The ship gains coins when touching a coin")
	ship_gains_coins.dependencies = [check_coin_group]

	var ship_gains_coins_01 := Check.new()
	ship_gains_coins_01.description = tr("The ship coins variable increases when touching a coin")
	ship_gains_coins_01.checker = func() -> String:
		var coins_before = ship.coins
		ship.coins = 0
		ship._on_area_entered(coin)
		var coins_after = ship.coins
		ship.coins = coins_before
		if coins_after != 1:
			return tr("The ship's coins variable should increase when touching a coin.")
		return ""

	var ship_gains_coins_02 := Check.new()
	ship_gains_coins_02.description = tr("The ship coins counter label increases when touching a coin")
	ship_gains_coins_02.checker = func() -> String:
		var coins_before = ship.coins
		ship.coins = 0
		ship._on_area_entered(coin)
		var coins_count_text = ship_coins_count.text
		ship.coins = coins_before
		if coins_count_text != "x1":
			return tr("The ship's coins counter label should update when touching a coin. We expected it to say 'x1' after collecting 1 coin but it displayed '%s' instead." % ship_coins_count.text)
		return ""

	var ship_gains_coins_03 := Check.new()
	ship_gains_coins_03.description = tr("The coin count doesn't change when the ship touches an energy pack")
	ship_gains_coins_03.checker = func() -> String:
		var coins_before = ship.coins
		ship.coins = 0
		ship._on_area_entered(energy_pack)
		var coins_after = ship.coins
		ship.coins = coins_before
		if coins_after != 0:
			return tr("The ship's coins variable should not change when touching an energy pack.")
		return ""

	ship_gains_coins.subchecks = [ship_gains_coins_01, ship_gains_coins_02, ship_gains_coins_03]


	var ship_gains_energy := Check.new()
	ship_gains_energy.description = tr("The ship gains energy when touching an energy pack")
	ship_gains_energy.dependencies = [check_energy_pack_group]

	var ship_gains_energy_01 := Check.new()
	ship_gains_energy_01.description = tr("The ship energy variable increases by 20 when touching an energy pack")
	ship_gains_energy_01.checker = func() -> String:
		var energy_before = ship.energy
		ship.energy = 0
		ship._on_area_entered(energy_pack)
		var energy_after = ship.energy
		ship.energy = energy_before
		if not is_equal_approx(energy_after, 20.0):
			return tr("The ship's energy variable should increase by 20 when touching an energy pack.")
		return ""

	var ship_gains_energy_02 := Check.new()
	ship_gains_energy_02.description = tr("The ship energy bar updates when touching an energy pack")
	ship_gains_energy_02.checker = func() -> String:
		var energy_before = ship.energy
		ship.energy = 0
		ship._on_area_entered(energy_pack)
		var energy_bar_after = ship_energy_bar.value
		ship.energy = energy_before
		if not is_equal_approx(energy_bar_after, ship.energy) and not is_equal_approx(energy_bar_after, 20.0):
			return (
				tr("The ship's energy bar should update when touching an energy pack.") +
				tr("After collecting an energy pack, the energy bar should be at 20, but it's at %s instead.") % energy_bar_after
			)
		return ""

	var ship_gains_energy_03 := Check.new()
	ship_gains_energy_03.description = tr("The energy variable doesn't change when the ship touches a coin")
	ship_gains_energy_03.checker = func() -> String:
		var energy_before = ship.energy
		ship.energy = 0
		ship._on_area_entered(coin)
		var energy_after = ship.energy
		ship.energy = energy_before
		if not is_equal_approx(energy_after, 0.0):
			return tr("The ship's energy variable should not change when touching a coin.")
		return ""

	ship_gains_energy.subchecks = [ship_gains_energy_01, ship_gains_energy_02, ship_gains_energy_03]

	checks = [
		check_coin_group,
		check_energy_pack_group,
		ship_gains_coins,
		ship_gains_energy,
	]
