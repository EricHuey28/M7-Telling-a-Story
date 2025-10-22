extends Control

@export_range(0.1, 10.0, 0.01, "or_greater") var opening_speed := 0.4

var _tween: Tween


func _ready() -> void:
	# We first get the nodes we need: the screen that moves when the menu button
	# is clicked, the button, and the panel container.
	# We need the panel container to get its size.
	# We don't use `@onready`:
	# We never need those nodes gain, they're only useful for connecting
	# the signal. They then are captured in the lambda; there's no need to
	# make them class members.
	var animated_screen: Control = %AnimatedScreen
	var drawer_button: Button = %DrawerButton
	var panel_container: PanelContainer = %PanelContainer
	# We extract the width of the panel
	var drawer_width := panel_container.size.x
	# Finally, we connect the button. The `toggled` signal only happens for
	# buttons that have `toggle_mode` set to `true`. These buttons act like
	# checkboxes.
	drawer_button.toggled.connect(func(is_toggled:bool) -> void:
		var speed := opening_speed
		# if there's a tween, and it is animating, kill it.
		# just checking for `null` isn't enough,
		if _tween != null and _tween.is_valid():
			# if the previous tween was animating, we want to animate back by the exact
			# elapsed time
			speed = _tween.get_total_elapsed_time()
			_tween.kill()
		# create a tween
		_tween = create_tween()
		# make the tween feel nice
		_tween.set_ease(Tween.EASE_OUT)
		_tween.set_trans(Tween.TRANS_QUART)
		# if the button is toggled, show the menu by moving the entire screen to the right
		if is_toggled:
			_tween.tween_property(animated_screen, "position:x", drawer_width, speed)
		# else, do the opposite
		else:
			_tween.tween_property(animated_screen, "position:x", 0, speed)
	)
	# and finally, we ensure the button is focused by default to enable immediate
	# interaction with spacebar/enter:
	drawer_button.grab_focus()
