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
	var texture_rect := _practice.texture_rect as TextureRect
	var label := _practice.label as Label
	var child_count := grid_container.get_child_count()
	
	var check_panel_updates := Check.new()
	check_panel_updates.description = tr("The panel should update when a button is pressed")
	
	check_panel_updates.checker = func() -> String:
		for child_idx in child_count:
			var child := grid_container.get_child(child_idx) as InventorySlotButton
			child.pressed.emit()
			if texture_rect.texture != child.texture:
				return tr("It looks like the texture isn't set when buttons are pressed")
			if label.text != child.text:
				return tr("It looks like the text isn't set when buttons are pressed")
		return ""
	
	checks = [check_panel_updates]
