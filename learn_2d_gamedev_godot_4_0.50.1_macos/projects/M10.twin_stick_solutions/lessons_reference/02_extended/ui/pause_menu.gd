class_name PauseMenu extends Control

@export_range(0, 1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount

var _tween: Tween

@onready var settings_button: Button = %SettingsButton
@onready var resume_button: Button = %ResumeButton

@onready var _quit_button: Button = %QuitButton

@onready var _color_rect: ColorRect = %ColorRect
@onready var _panel_container: PanelContainer = %PanelContainer


func _ready() -> void:
	menu_opened_amount = 0.0

	_quit_button.pressed.connect(get_tree().quit)


func set_menu_opened_amount(amount: float) -> void:
	menu_opened_amount = amount
	visible = amount > 0

	if _panel_container == null or _color_rect == null:
		return

	_panel_container.modulate.a = amount


func toggle(is_toggled: bool) -> void:
	var duration := 0.5
	if _tween != null:
		duration = _tween.get_total_elapsed_time()
		_tween.kill()

	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_QUART)

	var target_amount := 1.0 if is_toggled else 0.0
	_tween.tween_property(self, "menu_opened_amount", target_amount, duration)
