extends "res://addons/gdpractice/tester/test.gd"

func _build_requirements() -> void:
	_add_callable_requirement(
		"There should be an 'character_choices' Dictionary",
		func() -> String: 
			if not "character_choices" in _practice or (not _practice.character_choices is Dictionary) or _practice.character_choices.size() != _solution.character_choices.size():
				return tr("There is no 'character_choices' Array. Did you remove it? It's required for the practice to work")
			var keys = (_practice.character_choices as Dictionary).keys()
			for index in keys.size():
				var key := keys[index] as String 
				var item := _practice.character_choices[key] as Texture
				if item == null or key == null:
					return tr("It seems the dictionary was changed")
			return ""
	)


func _build_checks() -> void:
	var gobot_button_changes_texture := Check.new()
	gobot_button_changes_texture.description = tr("The Gobot button changes the displayed image")
	gobot_button_changes_texture.checker = func() -> String:
		var button := _practice.button_gobot as Button
		var target_texture := _practice.character_choices["gobot"] as Texture
		return _test_texture("ButtonGobot", target_texture)
	var nova_button_changes_texture := Check.new()
	nova_button_changes_texture.description = tr("The Nova button changes the displayed image")
	nova_button_changes_texture.checker = func() -> String:
		var button := _practice.button_gobot as Button
		var target_texture := _practice.character_choices["nova"] as Texture
		return _test_texture("ButtonNova", target_texture)
	checks = [gobot_button_changes_texture, nova_button_changes_texture]


func _test_texture(button_name: String, target_texture: Texture) -> String:
	var button := _practice.find_child(button_name) as Button
	if button == null:
		return "Cannot find button '%s'"%[button_name]
	var texture_rect := _practice.texture_rect as TextureRect
	button.pressed.emit()
	if texture_rect.texture == null:
		return tr("When we pressed the '%s' button, the texture was unchanged")%[button_name]
	if texture_rect.texture != target_texture:
		return tr("When we pressed the '%s' button, the texture was incorrectly set")%[button_name]
	return ""
