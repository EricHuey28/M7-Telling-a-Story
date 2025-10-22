extends CharacterBody2D

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var collision_shape_2d = %CollisionShape2D
@onready var cursor: Area2D = %Cursor

var max_speed := 600.0
var distance := 0.0
var direction := Vector2.ZERO
var duration := 0.0

var tween: Tween


func walk_to(destination_global_position: Vector2) -> void:
	# Calculate the distance and direction to the destination.
	distance = global_position.distance_to(destination_global_position) # distance = 0.0
	direction = global_position.direction_to(destination_global_position) # direction = Vector2()
	# Make sure to calculate the duration based on the distance to the target.
	duration =  distance / max_speed # duration = 0

	# This code ensures that if the player clicks quickly, the previous "walk
	# to" animation is cancelled and cannot conflict with the new destination.
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position", destination_global_position, duration)

	rotation = direction.orthogonal().angle()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_pressed() == false:
			walk_to(cursor.global_position)
