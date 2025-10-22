#ANCHOR:extends
extends Area2D
#END:extends

#ANCHOR:export_possible_items
@export var possible_items: Array[PackedScene] = []
#END:export_possible_items

#ANCHOR:L5_code
@onready var canvas_group: CanvasGroup = $CanvasGroup
#ANCHOR:animation_player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#END:animation_player

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	canvas_group.material.set_shader_parameter("line_thickness", 3.0)

func set_outline_thickness(new_thickness: float) -> void:
	canvas_group.material.set_shader_parameter("line_thickness", new_thickness)

#ANCHOR:func_on_mouse_entered_definition
func _on_mouse_entered() -> void:
#END:func_on_mouse_entered_definition
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 3.0, 6.0, 0.08)

#ANCHOR:func_on_mouse_exited_definition
func _on_mouse_exited() -> void:
#END:func_on_mouse_exited_definition
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 6.0, 3.0, 0.08)

#ANCHOR:_input_event_definition
func _input_event(viewport: Viewport, event: InputEvent, shape_index: int):
#END:_input_event_definition
#ANCHOR:boolean_expression
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
#END:boolean_expression

#ANCHOR:if_is_mouse_click
	if event_is_mouse_click:
#END:if_is_mouse_click
#ANCHOR:call_open
		open()
#END:call_open

#ANCHOR:open_definition
func open() -> void:
#END:open_definition
#ANCHOR:play_open_animation
	animation_player.play("open")
#END:play_open_animation

#ANCHOR:disconnect_input
	input_pickable = false
#END:disconnect_input
#END:L5_code

#ANCHOR:no_items_check
	if possible_items.is_empty():
		return
#END:no_items_check

#ANCHOR:spawn_random_items
	for current_index in range(randi_range(1, 3)):
		_spawn_random_item()
#END:spawn_random_items

#ANCHOR:spawn_random_item_complete
#ANCHOR:spawn_random_item_definition
func _spawn_random_item() -> void:
#END:spawn_random_item_definition
#ANCHOR:instantiate_item
	var loot_item: Area2D = possible_items.pick_random().instantiate()
	add_child(loot_item)
#END:instantiate_item

#ANCHOR:random_angle
	var random_angle := randf_range(0.0, 2.0 * PI)
#END:random_angle
#ANCHOR:random_direction
	var random_direction := Vector2(1.0, 0.0).rotated(random_angle)
#END:random_direction
#ANCHOR:random_distance
	var random_distance := randf_range(60.0, 120.0)
#END:random_distance
#ANCHOR:position_item
	loot_item.position = random_direction * random_distance
#END:position_item
#END:spawn_random_item_complete
