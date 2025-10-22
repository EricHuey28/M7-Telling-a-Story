extends "res://addons/gdpractice/tester/test.gd"

func _build_requirements() -> void:
	_add_callable_requirement(
		"There should be an 'items' Array",
		func() -> String: 
			if not "items" in _practice or (not _practice.items is Array) or _practice.items.size() != _solution.items.size():
				return tr("There is no 'items' Array. Did you remove it? It's required for the practice to work")
			for index in _practice.items.size():
				var item := _practice.items[index] as Dictionary
				if not (item is Dictionary) or \
					not "name" in item or\
					not (item.name is String and item.name.length() > 1) or\
					not "portrait" in item or\
					not (item.portrait is Texture):
						return tr("It seems the item '%s' is not correctly set up. Did you change the array?")%[index]
			return ""
	)
	_add_callable_requirement(
		"There should be an 'item_index' int",
		func() -> String: 
			if not "item_index" in _practice or not (_practice.item_index is int):
				return tr("There is no 'item_index' number. Did you remove it? It's required for the practice to work")
			if _practice.item_index != 0:
				return tr("We expect 'item_index' to be equal to zero for our tests. Make sure to not change its starting number!")
			return ""
	)
	_add_callable_requirement(
		"There should be a 'show_party_member' function",
		func() -> String: 
			if not "show_party_member" in _practice or not (_practice.show_party_member is Callable):
				return tr("There is no 'show_party_member' function. Did you remove it? It's required for the practice to work")
			return ""
	)
	_add_callable_requirement(
		"There should be an 'advance' function",
		func() -> String: 
			if not "advance" in _practice or not (_practice.advance is Callable):
				return tr("There is no 'advance' function. Did you remove it? It's required for the practice to work")
			return ""
	)
	_add_callable_requirement(
		"There should be an 'rewind' function",
		func() -> String: 
			if not "rewind" in _practice or not (_practice.rewind is Callable):
				return tr("There is no 'rewind' function. Did you remove it? It's required for the practice to work")
			return ""
	)

func _build_checks() -> void:
	
	var check_index_is_incremented := Check.new()
	check_index_is_incremented.description = tr("The index should increment when pressing the next button")
	
	check_index_is_incremented.checker = func() -> String:
		_practice.item_index = 0
		for index in _practice.items.size():
			if _practice.item_index != index:
				_practice.item_index = 0
				return tr("It looks like item_index isn't changing. We expected it to be '%s', but it is '%s'"%[_practice.item_index, index])
			(_practice.button_next as Button).pressed.emit()
		_practice.item_index = 0
		return ""
	
	var check_index_is_decremented := Check.new()
	check_index_is_decremented.description = tr("The index should decrement when pressing the previous button")
	
	check_index_is_decremented.checker = func() -> String:
		_practice.item_index = _practice.items.size() - 1
		for index in range(_practice.items.size() - 1, 0, -1):
			if _practice.item_index != index:
				_practice.item_index = 0
				return tr("It looks like item_index isn't changing. We expected it to be '%s', but it is '%s'"%[_practice.item_index, index])
			(_practice.button_previous as Button).pressed.emit()
		_practice.item_index = 0
		return ""
	
	var function_displays_text := Check.new()
	function_displays_text.description = tr("The 'show_party_member' function should properly display the text")
	
	function_displays_text.checker = func() -> String:
		_practice.item_index = 0
		for index in _practice.items.size():
			_practice.item_index = index
			_practice.show_party_member()
			if _practice.rich_text_label.text != _practice.items[index]["name"]:
				_practice.item_index = 0
				return tr("It looks like 'show_party_member' isn't setting the text properly. We expected the text to be '%s', but it is '%s'."%[_practice.items[index], _practice.rich_text_label.text])
		_practice.item_index = 0
		return ""
	
	var function_displays_images := Check.new()
	function_displays_images.description = tr("The 'show_party_member' function should properly display the image")
	
	function_displays_images.checker = func() -> String:
		_practice.item_index = 0
		for index in _practice.items.size():
			_practice.item_index = index
			_practice.show_party_member()
			if _practice.texture_rect.texture != _practice.items[index]["portrait"]:
				_practice.item_index = 0
				return tr("It looks like 'show_party_member' isn't setting the image properly.")
		_practice.item_index = 0
		return ""
	
	var button_next_calls_the_function := Check.new()
	button_next_calls_the_function.description = tr("The 'advance' function should trigger 'show_party_member' when the button is pressed")
	
	button_next_calls_the_function.checker = func() -> String:
		var button := _practice.button_next as Button
		if not button.pressed.is_connected(_practice.advance):
			return tr("the button is not connected to the 'advance' function. Did you remove that connection?")
		_practice.item_index = 0
		for index in _practice.items.size():
			var next_index: int = (index + 1) % _practice.items.size()
			button.pressed.emit()
			if _practice.item_index != next_index:
				return tr("it doesn't seem like pressing the button increments the item_index variable.")
			if _practice.texture_rect.texture != _practice.items[next_index]["portrait"]:
				return tr("It looks like 'show_party_member' isn't setting the image. Did you forget to set it?")
			if _practice.rich_text_label.text != _practice.items[next_index]["name"]:
				return tr("It looks like 'show_party_member' isn't setting the text. Did you forget to set it?")
		_practice.item_index = 0
		return ""
	
	var button_previous_calls_the_function := Check.new()
	button_previous_calls_the_function.description = tr("The 'rewind' function should trigger 'show_party_member' when the button is pressed")
	
	button_previous_calls_the_function.checker = func() -> String:
		var button := _practice.button_previous as Button
		if not button.pressed.is_connected(_practice.rewind):
			return tr("the button is not connected to the 'rewind' function. Did you remove that connection?")
		_practice.item_index = _practice.items.size() - 1
		for index in range(_practice.items.size() - 1, 0, -1):
			var next_index: int = index - 1
			if next_index < 0:
				next_index = _practice.items.size() - 1
			button.pressed.emit()
			if _practice.item_index != next_index:
				return tr("it doesn't seem like pressing the button decrements the item_index variable.")
			if _practice.texture_rect.texture != _practice.items[next_index]["portrait"]:
				return tr("It looks like 'show_party_member' isn't setting the image. Did you forget to set it?")
			if _practice.rich_text_label.text != _practice.items[next_index]["name"]:
				return tr("It looks like 'show_party_member' isn't setting the text. Did you forget to set it?")
		_practice.item_index = 0
		return ""
	
	checks = [check_index_is_incremented, check_index_is_decremented, function_displays_text, function_displays_images, button_next_calls_the_function, button_previous_calls_the_function]
	
	
