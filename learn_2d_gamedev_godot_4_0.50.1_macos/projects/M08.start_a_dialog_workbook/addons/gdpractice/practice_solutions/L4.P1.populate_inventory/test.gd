extends "res://addons/gdpractice/tester/test.gd"

func _build_requirements() -> void:
	_add_callable_requirement(
		"There should be an 'items_list' dictionary",
		func() -> String:
			if not "items_list" in _practice or (not _practice.items_list is Dictionary):
				return tr("There is no 'items_list' dictionary. Did you remove it? It's required for the practice to work.")
			return ""
	)
	_add_callable_requirement(
		"There should be an 'items_list' dictionary",
		func() -> String:
			if _practice.items_list.size() < 1:
				return tr("There is no items in the 'items_list' dictionary. Having some items is required.")
			return ""
	)
	_add_callable_requirement(
		"'items_list' should be a dictionary of string keys and int values",
		func() -> String:
			for index in _practice.items_list.size():
				var key = _practice.items_list.keys()[index]
				var value = _practice.items_list[key]
				if not (key is String):
					return tr("The 'items_list' dictionary key #%s isn't a string.")%[index]
				if not (value is int):
					return tr("The 'items_list' dictionary value '%s' isn't a string.")%[key]
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
	var child_count := grid_container.get_child_count()
	var items_list := _practice.items_list as Dictionary
	
	var check_buttons_are_created := Check.new()
	check_buttons_are_created.description = tr("The grid should have buttons as children")
	
	check_buttons_are_created.checker = func() -> String:
		if child_count == 0:
			return tr("There are no buttons added to the grid container. Did you forget to call add_child?")
		for child_idx in child_count:
			var child := grid_container.get_child(child_idx)
			if not (child is InventorySlotButton):
				return tr("Child #%s is not an InventorySlotButton")%[child_idx]
		return ""
	
	var check_buttons_equal_dictionary := Check.new()
	check_buttons_equal_dictionary.description = tr("There should be as many buttons created as there are keys in the dictionary")
	
	check_buttons_equal_dictionary.checker = func() -> String:
		if child_count != items_list.size():
			return tr("The dictionary has #%s keys, while there are #%s buttons created")%[child_count, items_list.size()]
		return ""
	
	var check_buttons_keys := Check.new()
	check_buttons_keys.description = tr("Button's text should equal the dictionary's keys")
	
	check_buttons_keys.checker = func() -> String:
		if child_count == 0:
			return tr("There are no buttons in the practice to test their text.")
		for child_idx in child_count:
			var button: InventorySlotButton = grid_container.get_child(child_idx)
			var key = items_list.keys()[child_idx]
			if button.text != key:	
				return tr("They key #%s is '%s', but the button's text is '%s'")%[child_count, key, button.text if button.text != "" else "null"]
		return ""
	
	var check_buttons_values := Check.new()
	check_buttons_values.description = tr("Button's amount should equal the dictionary's keys")
	
	check_buttons_values.checker = func() -> String:
		if child_count == 0:
			return tr("There are no buttons in the practice to check their values")
		for child_idx in child_count:
			var button: InventorySlotButton = grid_container.get_child(child_idx)
			var value = items_list.values()[child_idx]
			if button.amount != value:
				return tr("They value #%s is '%s', but the button's amount is set to '%s'")%[child_count, value, button.amount if button.amount != 0 else "null"]
		return ""
	checks = [check_buttons_are_created, check_buttons_equal_dictionary, check_buttons_keys, check_buttons_values]
