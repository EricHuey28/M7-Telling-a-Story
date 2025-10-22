#ANCHOR:header
@tool
#ANCHOR:class_declaration
extends Control

@onready var _blur_color_rect: ColorRect = %BlurColorRect
@onready var _ui_panel_container: PanelContainer = %UIPanelContainer
#END:class_declaration
#END:header

## Controls how much the menu is opened. This isn't actually used in the running game
## but it allows us to preview the menu animation in the editor.
#ANCHOR:export_menu_opened_amount
@export_range(0, 1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount
#END:export_menu_opened_amount

## How fast the pause menu opens
#ANCHOR:export_animation_duration
@export_range(0.1, 10.0, 0.01, "or_greater") var animation_duration := 2.3
#END:export_animation_duration

#ANCHOR:_tween_declaration
var _tween: Tween
#END:_tween_declaration

#ANCHOR:_is_currently_opening
var _is_currently_opening := false
#END:_is_currently_opening

#ANCHOR:_ready
@onready var _resume_button: Button = %ResumeButton
@onready var _quit_button: Button = %QuitButton


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	menu_opened_amount = 0.0

	_resume_button.pressed.connect(toggle)
	_quit_button.pressed.connect(get_tree().quit)
#END:_ready


## Called when [member menu_opened_amount] is changed.
#ANCHOR:set_menu_opened_signature
func set_menu_opened_amount(amount: float) -> void:
#END:set_menu_opened_signature
#ANCHOR:set_menu_opened_visible
	menu_opened_amount = amount
	visible = amount > 0
#END:set_menu_opened_visible
	# we set the value
	# we ensure the nodes exist (in case the function gets called before _ready)
#ANCHOR:skip_if_not_in_tree
	if _ui_panel_container == null or _blur_color_rect == null:
		return
	#END:skip_if_not_in_tree
	# we lerp all the values between 0 and 1, the two regular extremes of the
	# menu_opened_amount variable.
	# first, the shader. We set the blur amount and the saturation
#ANCHOR:blur_amount
	_blur_color_rect.material.set_shader_parameter("blur_amount", lerp(0.0, 1.5, amount))
#END:blur_amount
#ANCHOR:saturation
	_blur_color_rect.material.set_shader_parameter("saturation", lerp(1.0, 0.3, amount))
#END:saturation
#ANCHOR:tint_strength
	_blur_color_rect.material.set_shader_parameter("tint_strength", lerp(0.0, 0.2, amount))
#END:tint_strength
#ANCHOR:transparency
	_ui_panel_container.modulate.a = amount
#END:transparency
#ANCHOR:pause
	if not Engine.is_editor_hint():
		get_tree().paused = amount > 0.3
#END:pause


#ANCHOR:toggle
func toggle() -> void:
	# Switch the flag to the opposite value
	#ANCHOR:do_the_toggle
	_is_currently_opening = not _is_currently_opening
	#END:do_the_toggle

	var duration := animation_duration
	# If there's a tween, and it is animating, we want to kill it.
	# This stops the previous animation.
  #ANCHOR:handle_previous_tween
	if _tween != null:
		if not _is_currently_opening:
			# If the previous tween was animating, we want to animate back
			# from the current point in the animation.
			duration = _tween.get_total_elapsed_time()
		_tween.kill()
	#END:handle_previous_tween

	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_QUART)

	#ANCHOR:target_amount
	var target_amount := 1.0 if _is_currently_opening else 0.0
	#END:target_amount
	_tween.tween_property(self, "menu_opened_amount", target_amount, duration)

#END:toggle


#ANCHOR:_input
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle()
#END:_input
