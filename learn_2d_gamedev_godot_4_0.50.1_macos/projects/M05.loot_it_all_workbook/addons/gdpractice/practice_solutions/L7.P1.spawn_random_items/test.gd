extends "res://addons/gdpractice/tester/test.gd"


var RandomCollectiblePlacerScene: PackedScene = load("res://practices/L7.P1.spawn_random_items/random_collectible_placer.tscn")
# Our copy of the random placer to use in tests, by manually calling its _on_timer_timeout function.
var random_collectible_placer = RandomCollectiblePlacerScene.instantiate()


class TestData:
	var practice_spawned_collectibles: Array[String] = []
	var solution_spawned_collectibles: Array[String] = []

	var practice_spawned_positions: Array[Vector2] = []
	var solution_spawned_positions: Array[Vector2] = []


func _build_requirements() -> void:
	_add_callable_requirement(
		"There should be a property named collectible_scenes in the random collectible placer",
		func(): 
			if not "collectible_scenes" in random_collectible_placer:
				return "There is no property named collectible_scenes in the random collectible placer script. Did you remove it? It's required for the practice to work"
			return ""
	)


func _setup_populate_test_space() -> void:
	seed(1)
	add_child(random_collectible_placer)
	random_collectible_placer.hide()
	var timer: Timer = random_collectible_placer.get_node("Timer")
	timer.stop()

	var solution_node := _solution.get_node("RandomCollectiblePlacer")
	var practice_node := _practice.get_node("RandomCollectiblePlacer")
	
	if practice_node.collectible_scenes.size() > 1:
		solution_node.collectible_scenes = practice_node.collectible_scenes

	var practice_timer: Timer = practice_node.get_node("Timer")
	var solution_timer: Timer = solution_node.get_node("Timer")

	var test_data = TestData.new()
	const TEST_SPAWN_COUNT := 8
	seed(1)
	for i in TEST_SPAWN_COUNT:
		practice_node._on_timer_timeout()

	for node in practice_node.get_children():
		if node is Area2D:
			test_data.practice_spawned_collectibles.append(node.get_groups().front())
			test_data.practice_spawned_positions.append(node.position)
			node.queue_free()

	seed(1)
	for i in TEST_SPAWN_COUNT:
		solution_node._on_timer_timeout()
	for node in solution_node.get_children():
		if node is Area2D:
			test_data.solution_spawned_collectibles.append(node.get_groups().front())
			test_data.solution_spawned_positions.append(node.position)
			node.queue_free()
		
	await get_tree().create_timer(2.5).timeout

	_test_space.append(test_data)


func _build_checks() -> void:
	var CoinScene := load("res://practices/L7.P1.spawn_random_items/coin.tscn")
	var EnergyPackScene := load("res://practices/L7.P1.spawn_random_items/energy_pack.tscn")

	var check_loaded_scenes := Check.new()
	check_loaded_scenes.description = tr("The collectible_scenes array contains the coin and energy pack scenes")
	check_loaded_scenes.checker = func() -> String:
		var collectible_scenes: Array = _practice.get_node("RandomCollectiblePlacer").collectible_scenes
		if not collectible_scenes.has(CoinScene):
			for instance in collectible_scenes:
				if "practices/" in instance.resource_path and "coin.tscn" in instance.resource_path:
					return (
						tr("It appears that you loaded a coin scene from another practice. Please use the coin scene from this practice: ") + CoinScene.resource_path
					)
			return (
				tr("The collectible_scenes array should contain the coin scene, %s." % CoinScene.resource_path) +
				tr("Did you forget to load it?")
			)
		if not collectible_scenes.has(EnergyPackScene):
			for instance in collectible_scenes:
				if "practices/" in instance.resource_path and "energy_pack.tscn" in instance.resource_path:
					return (
						tr("It appears that you loaded an energy pack scene from another practice. Please use the energy pack scene from this practice: ") + EnergyPackScene.resource_path
					)
			return (
				tr("The collectible_scenes array should contain the energy pack scene, %s." % EnergyPackScene.resource_path) +
				tr("Did you forget to load it?")
			)
		return ""

	var check_spawn_collectible := Check.new()
	check_spawn_collectible.description = tr("The random collectible placer spawns collectibles in its _on_timer_timeout function")
	check_spawn_collectible.checker = func() -> String:
		var child_count_before := random_collectible_placer.get_child_count()
		random_collectible_placer._on_timer_timeout()
		var child_count_after := random_collectible_placer.get_child_count()
		if child_count_after == child_count_before:
			return (
				tr("The random collectible placer did not appear to spawn a collectible.") +
				tr("Did you forget to instantiate the collectible scene? Or to add it as a child?")
			)
		return ""

	var check_collectible_sequence := Check.new()
	check_collectible_sequence.description = tr("The random collectible placer spawns collectibles in a random sequence using the pick_random() function")
	check_collectible_sequence.dependencies = [check_spawn_collectible]
	check_collectible_sequence.checker = func() -> String:
		var data: TestData = _test_space.front()
		for index in range(data.practice_spawned_collectibles.size()):
			var practice_collectible: String = data.practice_spawned_collectibles[index]
			var solution_collectible: String = data.solution_spawned_collectibles[index]
			if not data.practice_spawned_positions[index].is_equal_approx(data.solution_spawned_positions[index]):
				return (
					tr("The collectible spawned at index %d in the practice scene is not in the same position as in the solution." % index) +
					"\n\n" +
					tr("Did you randomize the position of the collectible? In this practice, you should only randomize the collectible type without changing the position.")
				)
			if practice_collectible != solution_collectible:
				return (
					tr("The collectible spawned at index %d in the practice scene is not the same as the one in the solution scene." % index) +
					tr("Did you forget to use the pick_random() function to select a collectible scene?")
				)
		return ""

	checks = [check_loaded_scenes, check_spawn_collectible, check_collectible_sequence]
