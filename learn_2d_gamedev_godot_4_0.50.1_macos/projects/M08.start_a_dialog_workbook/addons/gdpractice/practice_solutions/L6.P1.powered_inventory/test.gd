extends "res://addons/gdpractice/tester/test.gd"

# have to reproduce the default types because we can't examing built-in enums
enum TYPE{
	NIL = 0,
	BOOL = 1,
	INT = 2,
	FLOAT = 3,
	STRING = 4,
}

func _build_requirements() -> void:
	_add_callable_requirement(
		"There should be an 'items_list' array",
		func() -> String:
			if not "items_list" in _practice or (not _practice.items_list is Array):
				return tr("There is no 'items_list' array. Did you remove it? It's required for the practice to work.")
			return ""
	)
	_add_callable_requirement(
		"'items_list' should be an array of resources",
		func() -> String:
			var items_list = _practice.items_list as Array
			var typed_class_name := ((items_list as Array).get_typed_script() as GDScript).resource_path
			if not typed_class_name.ends_with("powered_item.gd"):
				return tr("The array 'items_list' should be typed as an array of 'PoweredItem'. Did you modify it?")
			for index in fixed_data.item_count:
				var value = items_list[index]
				if value == null:
					return tr("Item %s in the array is 'null'. There should be no null elements")%[index]
				if not (value is Resource):
					return tr("Item %s in the array is not of the correct type. There should be only ShoppingEntry elements")%[index]
			return ""
	)
	_add_callable_requirement(
		"There should be a 'grid_container' node",
		func() -> String:
			if not ('grid_container' in _practice):
				return tr("There is no 'grid_container' property. Did you remove it?")
			if _practice.get_node("%GridContainer") == null:
				return tr("There is no 'GridContainer' node. Did you remove it?")
			if _practice.grid_container == null:
				return tr("The 'GridContainer' node is not set. Did you remove it?")
			return ""
	)
	_add_callable_requirement(
		"There is a 'powered_item.gd' script",
		func() -> String:
			var script = _load("powered_item.gd")
			if script == null:
				return tr("The script 'powered_item.gd' could not be loaded from the practice folder. Did you remove it?")
			return ""
	)
	_add_callable_requirement(
		"There is a 'power.gd' script",
		func() -> String:
			var script = _load("power.gd")
			if script == null:
				return tr("The script 'power.gd' could not be loaded from the practice folder. Did you remove it?")
			return ""
	)

# Data points collected once to use in practice checks.
class FixedTestData:
	var item_count := 0

	var has_powerups_list := false
	var has_powerups_list_type := false
	var all_powerups_have_power := true

	var power_has_image_property := false

	var are_any_powerups_displayed := false
	var are_powerups_accumulating := false

	var are_correct_powerups_displayed := true
	var are_correct_textures_displayed := true


var fixed_data := FixedTestData.new()

func _setup_populate_test_space() -> void:
	var grid_container := _practice.grid_container as GridContainer
	var powerups_v_box_container := _practice.powerups_v_box_container as VBoxContainer
	var button_count := grid_container.get_child_count()
	var items_list = _practice.items_list as Array[Resource]

	fixed_data.item_count = items_list.size()

	var powered_item_script = _load("powered_item.gd")
	var instance = powered_item_script.new()
	fixed_data.has_powerups_list = 'powerups_list' in instance

	var script := instance.powerups_list.get_typed_script() as GDScript
	var script_path := script.resource_path if script != null else ""
	fixed_data.has_powerups_list_type = script_path.ends_with("power.gd")
	
	var power_script = _load("power.gd") 
	var power_instance = power_script.new()
	fixed_data.power_has_image_property = 'image' in power_instance

	for powered_item in items_list:
		if not 'powerups_list' in powered_item or powered_item.powerups_list.is_empty():
			fixed_data.all_powerups_have_power = false
			break

	# Press every button, wait for one frame, and check if the powerups are cleaned and the right number of powerups is displayed per button
	if button_count == 0:
		fixed_data.are_any_powerups_displayed = false
		fixed_data.are_powerups_accumulating = true
		fixed_data.are_correct_powerups_displayed = false
	else:
		var button: InventorySlotButton = grid_container.get_child(0)
		var entry = items_list[0]
		var powerups_list = entry.powerups_list

		# Note: We test a single button because there are edge cases or race conditions ocurring with emitting
		# button.pressed in a loop, waiting for previous powerups icons being freed with
		# queue_free, and checking the new powerups icons.
		# Using await get_tree().process_frame delays something in the engine,
		# causing the data read to be incorrect.
		# So, I use a signal connection and lambda instead.
		button.pressed.emit()
		button.pressed.emit()

		get_tree().process_frame.connect(
			func ():
				# For each powered item button, check the powerups are displayed correctly
				var count := powerups_v_box_container.get_child_count()
				if count > 0:
					fixed_data.are_any_powerups_displayed = true
				if count > powerups_list.size():
					fixed_data.are_powerups_accumulating = true
				
				var powerups_count = powerups_list.size()
				if count != powerups_count or powerups_count == 0:
					fixed_data.are_correct_powerups_displayed = false

				for power_idx in powerups_count:
					var power := powerups_list[power_idx] as Resource
					var texture := power.image as Texture
					var power_texture := powerups_v_box_container.get_child(power_idx) as TextureRect
					if power_texture.texture != texture:
						fixed_data.are_correct_textures_displayed = false,
			CONNECT_ONE_SHOT
		)
	await get_tree().process_frame

func _build_checks() -> void:
	
	var grid_container := _practice.grid_container as GridContainer
	var powerups_v_box_container := _practice.powerups_v_box_container as VBoxContainer
	var child_count := grid_container.get_child_count()
	var items_list = _practice.items_list as Array[Resource]
	

	var check_powered_item_has_list := Check.new()
	check_powered_item_has_list.description = tr("The 'PoweredItem' script has an exported 'powerups_list' property with the type Array[Power]")
	check_powered_item_has_list.checker = func() -> String:
		if not fixed_data.has_powerups_list:
			return tr("'PoweredItem' does not have an array property called 'powerups_list'. Did you forget to add it?")
		if not fixed_data.has_powerups_list_type:
			return tr("'PoweredItem' has an array property called 'powerups_list', but it is not typed to 'Power'. Did you forget to specify the type?")
		return ""
	checks.append(check_powered_item_has_list)


	var check_there_is_at_least_one_powered_item := Check.new()
	check_there_is_at_least_one_powered_item.description = tr("There should be at least one 'PoweredItem' resource in the 'items_list' array")
	check_there_is_at_least_one_powered_item.checker = func() -> String:
		if items_list.is_empty():
			return tr("There are no 'PoweredItem' resources in the 'items_list' array. Did you forget to add them?")
		return ""
	checks.append(check_there_is_at_least_one_powered_item)


	var check_power_has_image_property := Check.new()
	check_power_has_image_property.description = "The 'Power' class has an 'image' property"
	check_power_has_image_property.checker = func() -> String:
		if not fixed_data.power_has_image_property:
			return tr("We found no 'image' property in the 'power.gd' script.")
		return ""
	checks.append(check_power_has_image_property)
	var check_powered_item


	var check_each_item_has_power := Check.new()
	check_each_item_has_power.description = tr("Each 'PoweredItem' should contain at least one power")
	check_each_item_has_power.checker = func() -> String:
		if items_list.is_empty():
			return tr("There needs to be at least one 'PoweredItem' resource in the 'items_list' array.")
		if not fixed_data.all_powerups_have_power:
				return tr("At least one 'PoweredItem' resource does not have a 'Power' in its 'powerups_list'. Did you forget to add powers?")
		return ""
	check_each_item_has_power.dependencies = [check_powered_item_has_list]
	checks.append(check_each_item_has_power)


	var check_there_is_one_button := Check.new()
	check_there_is_one_button.description = tr("There is at least one 'InventorySlotButton' in the grid container when the scene starts")
	check_there_is_one_button.checker = func() -> String:
		if child_count < 1:
			return tr("There are no buttons in the grid container. Did you write the code to add a button per 'PoweredItem' resource?")
		return ""
	check_there_is_one_button.dependencies = [check_there_is_at_least_one_powered_item]
	checks.append(check_there_is_one_button)


	var check_powerups_get_cleaned := Check.new()
	check_powerups_get_cleaned.description = "Pressing an item's button cleans up previously displayed powerups"
	check_powerups_get_cleaned.checker = func () -> String:
		if not fixed_data.are_any_powerups_displayed:
			return tr("Powerups are not shown in the interface. Did you forget to create the buttons?")
		if fixed_data.are_powerups_accumulating:
			return tr("Powerups are not cleaned between button presses. Did you remove previous children before adding new ones?")
		return ""
	check_each_item_has_power.dependencies = [check_there_is_one_button, check_each_item_has_power]
	checks.append(check_powerups_get_cleaned)


	var check_powerups_are_displayed := Check.new()
	check_powerups_are_displayed.description = "Displaying a 'Power' creates a little power icon"
	check_powerups_are_displayed.checker = func () -> String:
		if not fixed_data.are_correct_powerups_displayed:
			return tr("The number of powerups displayed does not match the number of 'Power' resources in the array. Did you add 'TextureRect' nodes to the 'VBoxContainer'?")

		if not fixed_data.are_correct_textures_displayed:
			return tr("It seems the icon isn't being set. Did you assign the power's 'image' property to the button's 'icon' property?")
		return ""
	check_powerups_are_displayed.dependencies = [check_there_is_one_button, check_there_is_at_least_one_powered_item, check_each_item_has_power]
	checks.append(check_powerups_are_displayed)


	var check_at_least_three_items := Check.new()
	check_at_least_three_items.description = tr("The items_list array should contain at least three items")
	check_at_least_three_items.checker = func() -> String:
		if fixed_data.item_count == 0:
			return tr("There are no items in the list! Please add three items to pass the test")
		elif fixed_data.item_count < 3:
			return tr("It seems the array has only %s items. Please add some more")%[fixed_data.item_count]
		return ""
	checks.append(check_at_least_three_items)

	
	var check_buttons_equal_dictionary := Check.new()
	check_buttons_equal_dictionary.description = tr("There should be as many buttons created as there are items in the array")
	check_buttons_equal_dictionary.checker = func() -> String:
		if child_count != fixed_data.item_count:
			return tr("The array has #%s keys, while there are #%s buttons created")%[child_count, fixed_data.item_count]
		return ""
	check_buttons_equal_dictionary.dependencies = [check_at_least_three_items]
	checks.append(check_buttons_equal_dictionary)
