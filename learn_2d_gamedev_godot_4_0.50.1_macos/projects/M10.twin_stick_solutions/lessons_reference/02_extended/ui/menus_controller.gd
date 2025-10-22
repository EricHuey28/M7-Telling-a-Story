extends Control

@onready var _pause_menu: PauseMenu = %PauseMenu
@onready var _settings_menu: SettingsMenu = %SettingsMenu


func _ready() -> void:
	_pause_menu.settings_button.pressed.connect(func () -> void:
		_settings_menu.show()
		_pause_menu.hide()
	)
	_settings_menu.go_back_button.pressed.connect(func () -> void:
		_settings_menu.hide()
		_pause_menu.show()
	)
	_pause_menu.resume_button.pressed.connect(
		toggle_pause.bind(false)
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		toggle_pause(not get_tree().paused)


func toggle_pause(new_state: bool) -> void:
	get_tree().paused = new_state
	_settings_menu.hide()
	_pause_menu.toggle(new_state)
