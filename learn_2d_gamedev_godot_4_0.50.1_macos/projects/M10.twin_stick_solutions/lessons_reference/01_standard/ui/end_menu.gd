#ANCHOR:extends
extends Control
#END:extends

@export_group("Confettis", "confettis_")
@export var confettis_amount := 5
@export var confettis_pop_time_delay := 0.5

#ANCHOR:l140_01
var _start_time := Time.get_ticks_msec()

@onready var _time_label: Label = %TimeLabel
#END:l140_01

#ANCHOR:l150_01
@onready var _replay_button: Button = %ReplayButton
@onready var _quit_button: Button = %QuitButton
#END:l150_01

@onready var _color_rect: ColorRect = %ColorRect
@onready var _panel_container: PanelContainer = %PanelContainer


#ANCHOR:l150_02
func _ready() -> void:
	visible = false
	_replay_button.pressed.connect(func () -> void:
		get_tree().paused = false
		get_tree().reload_current_scene()
	)
	_quit_button.pressed.connect(get_tree().quit)
	#END:l150_02


func animate_progress(amount := 0.0) -> void:
	_panel_container.modulate.a = amount


#ANCHOR:l140_02
func open() -> void:
	visible = true
	get_tree().paused = true

	var end_time := Time.get_ticks_msec()
	var total_time_msec := end_time - _start_time
	var total_time_s := snappedf(total_time_msec / 1000.0, 0.1)
	_time_label.text = "Time: " + str(total_time_s) + "s"
	#END:l140_02

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_method(animate_progress, 0.0, 1.0, 0.5)

	pop_confettis()


## Creates a few confetti emitters in random areas in the given radius and pops
## them in a staggered manner, then calls [signal finished].
func pop_confettis() -> void:
	var viewport_size := get_viewport_rect().size
	for _i in confettis_amount:
		await get_tree().create_timer(confettis_pop_time_delay).timeout

		var confettis: GPUParticles2D = preload("confettis.tscn").instantiate()
		add_child(confettis)

		confettis.global_position = Vector2(
			randf_range(0.0, viewport_size.x),
			viewport_size.y
		)
		confettis.emitting = true
