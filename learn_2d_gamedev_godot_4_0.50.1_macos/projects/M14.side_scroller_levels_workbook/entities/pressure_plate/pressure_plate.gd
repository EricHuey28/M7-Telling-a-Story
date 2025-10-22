class_name PressurePlate extends Area2D

## Emitted when the pressure plate is pressed or released.
signal pressed_state_changed(value: bool)

var is_pressed := false: set = set_is_pressed

@onready var _button_sprite: Sprite2D = %ButtonSprite


func _ready() -> void:
	body_entered.connect(func(_node: Node2D): _update_pressed_state())
	body_exited.connect(func(_node: Node2D): _update_pressed_state())


func set_is_pressed(value: bool) -> void:
	if is_pressed == value:
		return
	is_pressed = value
	pressed_state_changed.emit(is_pressed)
	# int(is_pressed) will be 1 if is_pressed is true, and 0 if it is false.
	# So this selects frame 1 if pressed, and frame 0 if not pressed.
	_button_sprite.frame = int(is_pressed)


# We use this function to check if the pressure plate is pressed. There can be
# multiple bodies standing on or touching the pressure plate, so we determine
# the pressed state by checking if any of the overlapping bodies is a
# CharacterBody2D (the plaeyr, a mob, or a pushable rock).
func _update_pressed_state() -> void:
	is_pressed = get_overlapping_bodies().any(func(body) -> bool: return body is CharacterBody2D)
