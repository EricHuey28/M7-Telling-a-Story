extends Area2D

@export var possible_items: Array[PackedScene] = []

@onready var canvas_group: CanvasGroup = $CanvasGroup
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	canvas_group.material.set_shader_parameter("line_thickness", 3.0)


func set_outline_thickness(new_thickness: float) -> void:
	canvas_group.material.set_shader_parameter("line_thickness", new_thickness)


func _on_mouse_entered() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 3.0, 6.0, 0.08)


func _on_mouse_exited() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 6.0, 3.0, 0.08)


func _input_event(viewport: Node, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	
	if event_is_mouse_click:
		open()


func open() -> void:
	input_pickable = false

	animation_player.play("open", 0.1)

	if possible_items.is_empty():
		return

	for current_index in range(randi_range(1, 7)):
		_spawn_random_item()


func _spawn_random_item() -> void:
	var loot_item: Area2D = possible_items.pick_random().instantiate()
	add_child(loot_item)


	var random_angle := randf_range(0.0, 2.0 * PI)
	var random_direction := Vector2(1.0, 0.0).rotated(random_angle)
	var random_distance := randf_range(60.0, 120.0)
#ANCHOR:land_position
	var land_position := random_direction * random_distance
#END:land_position

#ANCHOR:flight_time
	const FLIGHT_TIME := 0.4
	const HALF_FLIGHT_TIME := FLIGHT_TIME / 2.0
#END:flight_time


#ANCHOR:create_tween_1
	var tween := create_tween()
#END:create_tween_1
#ANCHOR:tween_1_parallel
	tween.set_parallel()
#END:tween_1_parallel
#ANCHOR:tween_1_scale
	loot_item.scale = Vector2(0.25, 0.25)
	tween.tween_property(loot_item, "scale", Vector2(1.0, 1.0), HALF_FLIGHT_TIME)
#END:tween_1_scale
#ANCHOR:tween_1_position_x
	tween.tween_property(loot_item, "position:x", land_position.x, FLIGHT_TIME)
#END:tween_1_position_x

#ANCHOR:create_tween_2
	tween = create_tween()
#END:create_tween_2
#ANCHOR:tween_2_set_trans
	tween.set_trans(Tween.TRANS_QUAD)
#END:tween_2_set_trans
#ANCHOR:tween_2_ease_out
	tween.set_ease(Tween.EASE_OUT)
#END:tween_2_ease_out
#ANCHOR:tween_2_position_y_1
	var jump_height := randf_range(30.0, 80.0)
	tween.tween_property(loot_item, "position:y", land_position.y - jump_height, HALF_FLIGHT_TIME)
#END:tween_2_position_y_1
#ANCHOR:tween_2_ease_in
	tween.set_ease(Tween.EASE_IN)
#END:tween_2_ease_in
#ANCHOR:tween_2_position_y_2
	tween.tween_property(loot_item, "position:y", land_position.y, HALF_FLIGHT_TIME)
#END:tween_2_position_y_2
