extends CharacterBody2D

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var collision_shape_2d = %CollisionShape2D
@onready var cursor: Area2D = %Cursor

var max_speed := 1600.0
var steering_factor := 1000.0
var target := global_position


func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(target)
	var desired_velocity := direction * max_speed
	velocity = velocity.move_toward(desired_velocity, steering_factor * delta)
	rotation = velocity.orthogonal().angle()
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_pressed() == false:
			target = cursor.global_position
