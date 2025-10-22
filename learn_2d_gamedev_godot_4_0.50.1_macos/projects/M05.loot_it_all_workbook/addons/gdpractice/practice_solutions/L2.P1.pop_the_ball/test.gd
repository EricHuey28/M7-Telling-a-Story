extends "res://addons/gdpractice/tester/test.gd"

var BallScene: PackedScene = load("res://practices/L2.P1.pop_the_ball/ball.tscn")

var ball: Area2D = BallScene.instantiate()


func _setup_populate_test_space() -> void:
	Input.action_press("move_right")
	await get_tree().create_timer(1.0).timeout
	Input.action_release("move_right")
	add_child(ball)
	ball.hide()


func _build_requirements() -> void:
	_add_actions_requirement(["move_right"])


func _build_checks() -> void:
	var check_collisions := Check.new()
	check_collisions.description = "The ball has a circular collision shape"

	var subcheck_collision_1 := Check.new()
	subcheck_collision_1.description = "The ball has a child CollisionShape2D node"
	subcheck_collision_1.checker = func() -> String:
		if not ball.has_node("CollisionShape2D"):
			return (
				tr("There should be a CollisionShape2D node as a child of the ball's root Area2D node in the ball scene. Did you forget to add it?") + "\n\n" +
				tr("If you added it to individual instances of the ball in the PopTheBall scene, the collision shapes will only exist for these ball instances, instead of every ball. You should add the CollisionShape2D node inside the ball scene instead.")
			)
		return ""
	
	var subcheck_collision_2 := Check.new()
	subcheck_collision_2.description = "The CollisionShape2D node has a CircleShape2D shape"
	subcheck_collision_2.checker = func() -> String:
		var collision_shape: CollisionShape2D = ball.get_node("CollisionShape2D")
		if collision_shape.shape == null:
			return tr("The CollisionShape2D node does not have a shape assigned. Did you forget to add a CircleShape2D shape to it?")
		if not collision_shape.shape is CircleShape2D:
			return tr("The CollisionShape2D node should have a CircleShape2D shape assigned to it. Instead, it has a %s shape assigned." % collision_shape.shape.get_class())
		return ""

	check_collisions.subchecks += [subcheck_collision_1, subcheck_collision_2]


	var check_area_entered_function := Check.new()
	check_area_entered_function.description = "The _on_area_entered function is defined in the ball script"
	check_area_entered_function.checker = func() -> String:
		if not ball.has_method("_on_area_entered"):
			return tr("The ball script should have a function named _on_area_entered. Did you forget to define it?")
		return ""

	var check_signal_connected := Check.new()
	check_signal_connected.description = "The ball's area_entered signal is connected to the _on_area_entered function"
	check_signal_connected.dependencies += [check_area_entered_function]
	check_signal_connected.checker = func() -> String:
		if not ball.area_entered.is_connected(ball._on_area_entered):
			return tr("The ball's area_entered signal should be connected to the _on_area_entered function. Did you forget to connect it? You can do this in the ball's _ready() function.")
		return ""

	var check_deletion := Check.new()
	check_deletion.description = "The ball is deleted when something touches it"
	check_deletion.dependencies += [check_signal_connected]
	check_deletion.checker = func() -> String:
		var new_ball := BallScene.instantiate()
		add_child(new_ball)
		new_ball.hide()
		new_ball._on_area_entered(Area2D.new())
		if not new_ball.is_queued_for_deletion():
			return tr("The ball should be deleted when the area_entered signal emits. Did you not call queue_free() in the _on_area_entered function?")
		return ""

	checks += [check_collisions, check_area_entered_function, check_signal_connected, check_deletion]
