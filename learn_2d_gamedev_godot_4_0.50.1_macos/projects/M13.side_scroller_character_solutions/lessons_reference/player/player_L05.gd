extends CharacterBody2D

enum State {
	GROUND,
	JUMP,
	FALL
}

@export var acceleration := 700.0
@export var deceleration := 1400.0
@export var max_speed := 120.0
@export var jump_speed := 360.0
@export var air_acceleration := 500.0

var jump_gravity := 1200.0
var direction_x := 0.0
var current_state: State = State.GROUND

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D


func _ready() -> void:
	_transition_to_state(current_state)


func _physics_process(delta: float) -> void:
	#ANCHOR: physics_process_01
	direction_x = signf(Input.get_axis("move_left", "move_right"))

	match current_state:
		State.GROUND:
			process_ground_state(delta)
			#END: physics_process_01
		#ANCHOR: physics_process_02
		State.JUMP:
			process_jump_state(delta)
			#END: physics_process_02
		#ANCHOR: physics_process_03
		State.FALL:
			process_fall_state(delta)
			#END: physics_process_03

	#ANCHOR: physics_process_tail
	#ANCHOR: L05_physics_process_gravity
	velocity.y += jump_gravity * delta
	#END: L05_physics_process_gravity
	move_and_slide()
	#END: physics_process_tail


func process_ground_state(delta: float) -> void:
	#ANCHOR:horizontal_movement
	var is_moving := absf(direction_x) > 0.0
	if is_moving:
		velocity.x += acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)

		animated_sprite.flip_h = direction_x < 0.0
		animated_sprite.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		animated_sprite.play("Idle")
		#END:horizontal_movement

	#ANCHOR: initiate_jump
	if Input.is_action_just_pressed("jump"):
		_transition_to_state(State.JUMP)
		#END: initiate_jump
	#ANCHOR: transition_ground_to_fall
	elif not is_on_floor():
		_transition_to_state(State.FALL)
		#END: transition_ground_to_fall


func process_jump_state(delta: float) -> void:
	#ANCHOR: process_jump_state_horizontal_movement
	if direction_x != 0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		animated_sprite.flip_h = direction_x < 0.0
		#END: process_jump_state_horizontal_movement

	#ANCHOR: process_jump_state_to_fall
	if velocity.y >= 0:
		_transition_to_state(State.FALL)
		#END: process_jump_state_to_fall


func process_fall_state(delta: float) -> void:
	if direction_x != 0.0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		animated_sprite.flip_h = direction_x < 0.0

	if is_on_floor():
		_transition_to_state(State.GROUND)


func _transition_to_state(new_state: State) -> void:
	#ANCHOR:transition_01
	var previous_state := current_state
	current_state = new_state

	# Exit previous state
	#ANCHOR: match_previous_state
	match previous_state:
		#END:transition_01
		pass
		#END: match_previous_state

	# Enter new state
	# ANCHOR:transition_03_match_current
	match current_state:
		#END:transition_03_match_current
		#ANCHOR: transition_04_jump
		State.JUMP:
			#ANCHOR:transition_04_jump_velocity
			velocity.y = -1.0 * jump_speed
			#END:transition_04_jump_velocity
			animated_sprite.play("Jump")
			#END: transition_04_jump

		#ANCHOR: transition_05_fall
		State.FALL:
			animated_sprite.play("Fall")
			#END: transition_05_fall
