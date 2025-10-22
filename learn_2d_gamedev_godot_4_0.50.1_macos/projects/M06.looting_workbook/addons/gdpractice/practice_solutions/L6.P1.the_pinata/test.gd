extends "res://addons/gdpractice/tester/test.gd"

var practice_balloon: Area2D = null
var solution_balloon: Area2D = null

var simulated_candy_positions: Array[Vector2] = []


func _setup_state() -> void:
	var practice_balloons := _practice.find_children("", "Area2D")
	var solution_balloons := _solution.find_children("", "Area2D")
	practice_balloon = practice_balloons.front()
	solution_balloon = solution_balloons.front()

	# We use 1 for the seed because 0 causes randi_range(1, 3) or randi() % 4 to
	# output 3, which passes the test but should not.
	const TEST_SEED := 1

	await get_tree().create_timer(1.0).timeout
	var left_click_event := InputEventMouseButton.new()
	left_click_event.button_index = MOUSE_BUTTON_LEFT
	left_click_event.pressed = true
	for balloon in practice_balloons + solution_balloons:
		seed(TEST_SEED)
		balloon._input_event(get_viewport(), left_click_event, 0)
	seed(TEST_SEED)
	simulated_candy_positions = _simulate_candy_spawn_variation()


# This early in the course we don't want to introduce RandomNumberGenerator yet, which we need to reliably test random numbers.
# The problem is, when generating multiple numbers, the random generation is sensitive to the order in which we generate them.
# So we have this function that reproduces candy spawning. We can reset the seed, generate new candies, and compare the output with the student practice.
# Add a second copy of the code resetting the seed and swapping angle and radius calculations to test random generation
# with the two variables swapped.
func _simulate_candy_spawn_variation() -> Array[Vector2]:
	var possible_candies: Array[PackedScene] = [
		preload("./candy/candy_blue.tscn"),
		preload("./candy/candy_green.tscn"),
		preload("./candy/candy_red.tscn")
	]
	var candy_positions: Array[Vector2] = []
	for current_index in range(3):
		# This is required because instantiating and adding the candy as a child
		# changes the random number sequence. So, to match the student practice,
		# we need to instantiate the candies too.
		var candy: Node2D = possible_candies.pick_random().instantiate()
		add_child(candy)
		candy.hide()

		var angle := randf_range(0.0, 2.0 * PI)
		var radius := randf_range(0.0, 100.0)

		var random_direction := Vector2(1.0, 0.0).rotated(angle)
		var random_position := (radius * random_direction)

		candy_positions.append(random_position)
	return candy_positions


func _build_checks() -> void:
	_add_simple_check(
		tr("When clicked, the balloon always spawns 3 candies."),
		func() -> String:
			var hint := tr("Did you loop three times and add the candies as children of the balloon? Make sure you create exactly three candies and not a random number of them.")
			var candies: Array = practice_balloon.get_children().filter(is_candy)
			return "" if candies.size() == 3 else hint
	)

	_add_simple_check(
		tr("The candies are spawned at random positions around the balloon, within a 100 pixels radius."),
		func() -> String:
			var practice_candies := practice_balloon.get_children().filter(is_candy)
			var solution_candies := solution_balloon.get_children().filter(is_candy)

			var is_position_same_a: Array[bool] = []
			for idx in range(practice_candies.size()):
				is_position_same_a.push_back(practice_candies[idx].position.is_equal_approx(solution_candies[idx].position))

			var is_position_same_b: Array[bool] = []
			for idx in range(practice_candies.size()):
				is_position_same_b.push_back(practice_candies[idx].position.is_equal_approx(simulated_candy_positions[idx]))

			var identity_predicate := func(x: bool) -> bool: return x
			var hint := (
				tr("Did you forget to randomize the radius or angle of the generated position? The candies should be spawned at random positions around the balloon, is a circular area with a 100 pixels radius.") + "\n" +
				tr("Also, make sure that you kept the order of operations from the practice code. Otherwise, your code cannot be tested.")
			)
			return "" if is_position_same_a.all(identity_predicate) or is_position_same_b.all(identity_predicate) else hint
	)
	checks.back().dependencies.append(checks.front())


func is_candy(node: Node) -> bool:
	return node.is_in_group("candy")
