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
			var items_list = _practice.items_list
			var typed_class_name := ((items_list as Array).get_typed_script() as GDScript).resource_path
			if not typed_class_name.ends_with("shopping_entry.gd"):
				return tr("The array 'items_list' should be typed as an array of 'ShoppingEntry'. Did you modify it?")
			for index in items_list.size():
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


func _build_checks() -> void:
	
	var grid_container := _practice.grid_container as GridContainer
	var texture_rect := _practice.texture_rect as TextureRect
	var label := _practice.label as Label
	var child_count := grid_container.get_child_count()
	var items_list = _practice.items_list as Array[Resource]
	
	var check_at_least_three_items := Check.new()
	check_at_least_three_items.description = tr("The items_list array should contain at least three items")
	check_at_least_three_items.checker = func() -> String:
		if items_list.size() < 3:
			if items_list.size() == 0:
				return tr("There are no items in the list! Please add three items to pass the test")
			return tr("It seems the array has only %s items. Please add some more")%[items_list.size()]
		return ""
	checks = [check_at_least_three_items]
	
	var example_item := (items_list.get_typed_script() as GDScript).new() as Resource
	
	var checks_property_type := []
	var type_names := TYPE.keys() as Array
	for property_tuple in [['text', TYPE_STRING], ['amount', TYPE_INT], ['price', TYPE_INT]]:
		var property_name := property_tuple[0] as String
		var property_type := property_tuple[1] as int
		var property_type_human := type_names[property_type] as String
		
		var check_prop_name := Check.new()
		check_prop_name.description = tr("The 'ShoppingEntry' resource should have a '%s' property of type '%s'")%[property_name, property_type_human]
	
		check_prop_name.checker = func() -> String:
			if not (property_name in example_item):
				return tr("Property '%s' is missing from 'ShoppingEntry'") % [property_name]
			var current_type := typeof(example_item[property_name])
			var current_type_human := type_names[current_type] as String if type_names.size() > current_type else "unknown"
			if current_type != property_type:
				return tr("Property '%s' has an incorrect type. We expected '%s', we got '%s'")%[property_name, property_type_human, current_type_human]
			return ""
		checks.append(check_prop_name)
		checks_property_type.append(check_prop_name)


	var check_buttons_equal_dictionary := Check.new()
	check_buttons_equal_dictionary.description = tr("There should be as many buttons created as there are items in the array")
	check_buttons_equal_dictionary.checker = func() -> String:
		if items_list.size() < 1:
			return tr("There aren't enough items to check the buttons")
		if child_count != items_list.size():
			return tr("The array has #%s keys, while there are #%s buttons created")%[child_count, items_list.size()]
		return ""
	checks.append(check_buttons_equal_dictionary)


	var check_buttons_values := Check.new()
	check_buttons_values.description = tr("Button's properties should match the items in the array")
	check_buttons_values.checker = func() -> String:
		for item in items_list:
			if item.text == "" or item.amount == 0 or item.price == 0:
				return tr("One of the items in the array has an empty text, or an amount or price set to 0. Please change the resources' values to pass the test.")
		for child_idx in child_count:
			var button: InventorySlotButton = grid_container.get_child(child_idx)
			var entry = items_list[child_idx]
			for property_name in ['text', 'amount', 'price']:
				if not property_name in entry:
					return tr("The value for '%s' could not be checked")%[property_name]
				if button[property_name] != entry[property_name]:
					return tr("Button #%s's has '%s' set to '%s', but the corresponding entry has it set to '%s'. Did you forget to set the property?")%[child_count, property_name, entry[property_name],button[property_name]]
		return ""
	check_buttons_values.dependencies.assign(checks_property_type)
	checks.append(check_buttons_values)
