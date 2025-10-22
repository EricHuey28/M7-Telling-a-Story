extends "res://addons/gdpractice/tester/test.gd"

var balloon: Area2D = _load("balloon_sting.gd", true).new()

func _setup_state() -> void:
	add_child(balloon)
	balloon.visible = false

func _build_checks() -> void:
	_add_simple_check(
		tr("The mouse_entered signal is connected to the _on_mouse_entered() function."),
		func() -> String:
			var has_mouse_entered_signal:=balloon != null and balloon.mouse_entered.is_connected(balloon._on_mouse_entered)
			return "" if has_mouse_entered_signal else tr("Did you assign connect the mouse_entered signal to the _on_mouse_entered() function?")
	)

	var check_mouse_hover := Check.new()
	check_mouse_hover.description = tr("When the mouse hovers over the balloon, the balloon is freed.")
	check_mouse_hover.checker = func() -> String:
		var is_freed := balloon == null
		if not is_freed:
			balloon._on_mouse_entered()
			is_freed = balloon.is_queued_for_deletion()
		return "" if is_freed else tr("Did you call the queue_free() in the proper function?")
	check_mouse_hover.dependencies += [checks.back()]

	checks += [check_mouse_hover]
