extends "res://addons/gdpractice/tester/test.gd"

func _build_requirements() -> void:
	_add_callable_requirement(
		"There should be an 'items' array of Strings",
		func() -> String:
			if not "items" in _practice or (not _practice.items is Array) or _practice.items.size() != _solution.items.size():
				return tr("There is no 'items' array. Did you remove it? It's required for the practice to work")
			return ""
	)
	_add_callable_requirement(
		"There should be an 'item_index' int",
		func() -> String:
			if not "item_index" in _practice or not (_practice.item_index is int):
				return tr("There is no 'item_index' number. Did you remove it? It's required for the practice to work")
			return ""
	)
	_add_callable_requirement(
		"There should be a 'show_text' function",
		func() -> String:
			if not "show_text" in _practice or not (_practice.show_text is Callable):
				return tr("There is no 'show_text' function. Did you remove it? It's required for the practice to work")
			return ""
	)

func _build_checks() -> void:
	
	var expected: String = _solution.items[_solution.item_index]
	
	var check_index_is_correct := Check.new()
	check_index_is_correct.description = tr("The text should be set to '%s'" % [expected])
	
	check_index_is_correct.checker = func() -> String:
		var found = _practice.items[_practice.item_index]
		if found != expected:
			if _practice.response_label.text == expected:
				return tr("We found the text to be correct, but it seems you changed it in the `show_text()` function instead of modifying `item_index`")
			return tr("We didn't find the correct response! We expected '%s', and we got '%s'" % [expected, found])
		return ""

	checks = [check_index_is_correct]
