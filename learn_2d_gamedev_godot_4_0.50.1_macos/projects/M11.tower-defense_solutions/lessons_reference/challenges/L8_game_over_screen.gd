extends ColorRect

@onready var _retry_button: Button = %RetryButton
@onready var _quit_button: Button = %QuitButton


func _ready() -> void:
	visible = false
	# This is equivalent to changing the Process -> Mode property to Always in the Inspector
	process_mode = PROCESS_MODE_ALWAYS

	# Show the menu and pause the game when the player health depletes
	PlayerUI.health_depleted.connect(func() -> void:
		visible = true
		get_tree().paused = true
	)

	# When pressing the retry button, we need to reset the health
	# because the PlayerUI is an autoload; it won't reset automatically.
	_retry_button.pressed.connect(func() -> void:
		# You could also define a function named "reset()" in the PlayerUI script and call it here
		# to avoid hard-coding the number.
		PlayerUI.health = 5
		get_tree().reload_current_scene()
	)
	_quit_button.pressed.connect(get_tree().quit)
