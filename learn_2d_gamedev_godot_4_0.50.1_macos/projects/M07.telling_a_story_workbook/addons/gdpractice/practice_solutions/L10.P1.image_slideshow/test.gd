extends "res://addons/gdpractice/tester/test.gd"

func _build_requirements() -> void:
	_add_callable_requirement(
		"There should be an 'items' array of images",
		func() -> String: 
			if not "items" in _practice or (not _practice.items is Array) or _practice.items.size() != _solution.items.size():
				return tr("There is no 'items' array. Did you remove it? It's required for the practice to work")
			return ""
	)
	_add_callable_requirement(
		"There should be an 'item_index' int",
		func() -> String: 
			if not "item_index" in _practice or not (_practice.item_index is int):
				return "There is no 'item_index' number. Did you remove it? It's required for the practice to work"
			if _practice.item_index != 0:
				return tr("We expect 'item_index' to be equal to zero for our tests. Make sure to not change its starting number!")
			return ""
	)
	_add_callable_requirement(
		"There should be a 'show_image' function",
		func() -> String: 
			if not "show_image" in _practice or not (_practice.show_image is Callable):
				return tr("There is no 'show_image' function. Did you remove it? It's required for the practice to work")
			return ""
	)
	_add_callable_requirement(
		"There should be an 'advance' function",
		func() -> String: 
			if not "advance" in _practice or not (_practice.advance is Callable):
				return tr("There is no 'advance' function. Did you remove it? It's required for the practice to work")
			return ""
	)

func _build_checks() -> void:
	
	var check_index_is_incremented := Check.new()
	check_index_is_incremented.description = tr("The index should increment when pressing the button")
	
	check_index_is_incremented.checker = func() -> String:
		_practice.item_index = 0
		for index in _practice.items.size():
			if _practice.item_index != index:
				_practice.item_index = 0
				return tr("It looks like item_index isn't changing. We expected it to be '%s', but it is '%s'"%[_practice.item_index, index])
			(_practice.button as Button).pressed.emit()
		_practice.item_index = 0
		return ""
	
	var function_displays_images := Check.new()
	function_displays_images.description = tr("The 'show_image' function should properly display the text")
	
	function_displays_images.checker = func() -> String:
		_practice.item_index = 0
		for index in _practice.items.size():
			_practice.item_index = index
			_practice.show_image()
			if _practice.texture_rect.texture != _practice.items[index]:
				_practice.item_index = 0
				return tr("It looks like 'show_image' isn't setting the text properly. We expected the text to be '%s', but it is '%s'"%[_practice.items[index], _practice.texture_rect.texture])
		_practice.item_index = 0
		return ""
	
	var button_calls_the_function := Check.new()
	button_calls_the_function.description = tr("The 'advance' function trigger 'show_image' when the button is pressed")
	
	button_calls_the_function.checker = func() -> String:
		var button := _practice.button as Button
		if not button.pressed.is_connected(_practice.advance):
			return tr("the button is not connected to the 'advance' function. Did you remove that connection?")
		_practice.item_index = 0
		for index in _practice.items.size():
			var next_index: int = (index + 1) % _practice.items.size()
			button.pressed.emit()
			if _practice.item_index != next_index:
				return tr("it doesn't seem like pressing the button runs the 'advance' function. Did you connect it?.")
			if _practice.texture_rect.texture != _practice.items[next_index]:
				return tr("It looks like 'show_image' isn't being called when pressing the button. Did you remember to call it?")
		_practice.item_index = 0
		return ""
		
	checks = [check_index_is_incremented, function_displays_images, button_calls_the_function]
	
	
