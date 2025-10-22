extends "res://addons/gdpractice/tester/test.gd"

var ShipScene: PackedScene = load("res://practices/L5.P1.code_an_energy_pack/ship_energy_pack.tscn")

var ship: Area2D = ShipScene.instantiate()


func _setup_populate_test_space() -> void:
	Input.action_press("move_right")
	await get_tree().create_timer(1.0).timeout
	Input.action_release("move_right")
	add_child(ship)
	ship.position = -Vector2.ONE * 10_000
	ship.set_process(false)
	ship.hide()


func _build_requirements() -> void:
	_add_actions_requirement(["move_right"])

	var requirement := Requirement.new()
	requirement.description = tr("Missing energy property")
	requirement.checker =  func() -> String:
		return "" if "energy" in ship else tr("The ship should have an energy property")
	requirements.push_back(requirement)


func _build_checks() -> void:
	var ship = _practice.get_node("ShipEnergyPack")

	var capture_state := func capture_state () -> Callable:
		var previous_energy_level: float = ship.energy
		var energy_bar = ship.get_node_or_null("UI/EnergyBar")
		var previous_energy_bar_value: float = energy_bar.value if energy_bar != null else 0.0
		var restore := func restore() -> void:
			ship.energy = previous_energy_level
			if energy_bar != null:
				energy_bar.value = previous_energy_bar_value
		return restore

	var check_area_entered_function := Check.new()
	check_area_entered_function.description = "The _on_area_entered function is defined in the ship_energy_pack script"
	check_area_entered_function.checker = func() -> String:
		if not ship.has_method("_on_area_entered"):
			return tr("The ship's script should have a function named _on_area_entered. Did you forget to define it?")
		return ""

	var check_signal_connected := Check.new()
	check_signal_connected.description = "The ship's area_entered signal is connected to the _on_area_entered function"
	check_signal_connected.dependencies += [check_area_entered_function]
	check_signal_connected.checker = func() -> String:
		if not ship.area_entered.is_connected(ship._on_area_entered):
			return tr("The ship's area_entered signal should be connected to the _on_area_entered function. Did you forget to connect it? You can do this in the ship's _ready() function.")
		return ""


	var check_touching_increases_energy := Check.new()
	check_touching_increases_energy.description = "The ship's energy increases by 20 when it touches the energy pack"
	check_touching_increases_energy.dependencies += [check_signal_connected]
	check_touching_increases_energy.checker = func() -> String:
		var restore: Callable = capture_state.call()
		ship.energy = 0
		ship._on_area_entered(Area2D.new())
		var difference: float = ship.energy
		if not is_equal_approx(ship.energy, 20.0):
			restore.call()
			return tr("The ship's energy should increase by 20 when it touches the energy pack but it changed by %s instead. Did you forget to increase the energy in the _on_area_entered function?" % difference)
		restore.call()
		return ""

	var check_touching_updates_ui := Check.new()
	check_touching_updates_ui.description = "The energy bar updates when the ship touches the energy pack"
	check_touching_updates_ui.dependencies += [check_touching_increases_energy]
	check_touching_updates_ui.checker = func() -> String:
		var restore: Callable = capture_state.call()
		
		ship.energy = 0
		var energy_bar = ship.get_node_or_null("UI/EnergyBar")
		if energy_bar != null:
			energy_bar.value = 0


		ship._on_area_entered(Area2D.new())

		if energy_bar == null:
			restore.call()
			return tr("The ship should have a child node named UI with a child node named EnergyBar.")
		if not is_equal_approx(energy_bar.value, ship.energy):
			restore.call()
			return tr("The energy bar should update to match the ship's energy when the ship touches the energy pack. The energy bar's value property is %s, and the ship's energy is %s. Did you forget to update the energy bar in the _on_area_entered function?" % [energy_bar.value, ship.energy])
		restore.call()
		return ""

	checks += [check_area_entered_function, check_signal_connected, check_touching_increases_energy, check_touching_updates_ui]
