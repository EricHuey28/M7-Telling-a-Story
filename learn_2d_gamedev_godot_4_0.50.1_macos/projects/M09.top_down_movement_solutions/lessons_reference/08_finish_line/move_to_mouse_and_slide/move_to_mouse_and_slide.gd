#ANCHOR:file_header
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var collision_shape_2d = %CollisionShape2D
@onready var cursor: Area2D = %Cursor

var max_speed := 600.0
var target := global_position
#END:file_header

#ANCHOR:physics_signature
func _physics_process(_delta: float) -> void:
#END:physics_signature
	var distance := global_position.distance_to(target)
	if distance < 10.0:
		return
	var direction := global_position.direction_to(target)
	velocity = direction * max_speed
	rotation = direction.orthogonal().angle()
	move_and_slide()


#ANCHOR:input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_pressed() == false:
			target = cursor.global_position
#END:input
