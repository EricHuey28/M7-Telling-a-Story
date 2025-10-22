#ANCHOR:L06_code_ref_01
extends CharacterBody2D

enum State {
	GROUND,
	JUMP,
	FALL
}

@export var acceleration := 700.0
@export var deceleration := 1400.0
@export var max_speed := 120.0
@export var air_acceleration := 500.0
@export var max_fall_speed := 250.0

#ANCHOR:export_category_jump
@export_category("Jump")
#END:export_category_jump
@export_range(10.0, 200.0) var jump_height := 50.0
@export_range(0.1, 1.5) var jump_time_to_peak := 0.37
@export_range(0.1, 1.5) var jump_time_to_descent := 0.2
#END:L06_code_ref_01
@export_range(50.0, 200.0) var jump_horizontal_distance := 80.0
@export_range(5.0, 50.0) var jump_cut_divider := 15.0

#ANCHOR:L06_code_ref_02
var current_state: State = State.GROUND
var direction_x := 0.0
var current_gravity := 0.0

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

@onready var jump_speed := calculate_jump_speed(jump_height, jump_time_to_peak)
@onready var jump_gravity := calculate_jump_gravity(jump_height, jump_time_to_peak)
@onready var fall_gravity := calculate_fall_gravity(jump_height, jump_time_to_descent)
#END:L06_code_ref_02
@onready var jump_horizontal_speed := calculate_jump_horizontal_speed(jump_horizontal_distance, jump_time_to_peak, jump_time_to_descent)


func _ready() -> void:
	_transition_to_state(current_state)


func _physics_process(delta: float) -> void:
	#ANCHOR:physics_process_L06_head
	direction_x = signf(Input.get_axis("move_left", "move_right"))

	match current_state:
		State.GROUND:
			process_ground_state(delta)
		State.JUMP:
			process_jump_state(delta)
		State.FALL:
			process_fall_state(delta)
			#END:physics_process_L06_head

	#ANCHOR:physics_process_L06_gravity
	velocity.y += current_gravity * delta
	velocity.y = minf(velocity.y, max_fall_speed)
	#END:physics_process_L06_gravity
	#ANCHOR:physics_process_L06_move
	move_and_slide()
	#END:physics_process_L06_move


func process_ground_state(delta: float) -> void:
	var is_moving := absf(direction_x) > 0.0
	if is_moving:
		velocity.x += acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)

		animated_sprite.flip_h = direction_x < 0.0
		animated_sprite.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
		animated_sprite.play("Idle")

	if Input.is_action_just_pressed("jump"):
		_transition_to_state(State.JUMP)
	elif not is_on_floor():
		_transition_to_state(State.FALL)


func process_jump_state(delta: float) -> void:
	#ANCHOR:L06_process_jump_head
	#ANCHOR:L07_process_jump_head_part_01
	if direction_x != 0.0:
		velocity.x += air_acceleration * direction_x * delta
		#END:L07_process_jump_head_part_01
		#ANCHOR:L07_process_jump_horizontal_speed
		velocity.x = clampf(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
		#END:L07_process_jump_horizontal_speed
		#ANCHOR:L07_process_jump_head_part_02
		animated_sprite.flip_h = direction_x < 0.0
		#END:L07_process_jump_head_part_02
		#END:L06_process_jump_head

	#ANCHOR:L06_jump_cut
	if Input.is_action_just_released("jump"):
		var jump_cut_speed := jump_speed / jump_cut_divider
		if velocity.y < 0.0 and velocity.y < jump_cut_speed:
			velocity.y = jump_cut_speed
			#END:L06_jump_cut

	#ANCHOR:L06_process_jump_tail
	if velocity.y >= 0.0:
		_transition_to_state(State.FALL)
		#END:L06_process_jump_tail


func process_fall_state(delta: float) -> void:
	#ANCHOR:L07_process_fall_head_part_01
	if direction_x != 0.0:
		velocity.x += air_acceleration * direction_x * delta
		#END:L07_process_fall_head_part_01
		#ANCHOR:L07_process_fall_horizontal_speed
		velocity.x = clampf(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
		#END:L07_process_fall_horizontal_speed
		#ANCHOR:L07_process_fall_head_part_02
		animated_sprite.flip_h = direction_x < 0.0
	#END:L07_process_fall_head_part_02

	if is_on_floor():
		_transition_to_state(State.GROUND)


func _transition_to_state(new_state: State) -> void:
	#ANCHOR:transition_L06_code_ref_01
	var previous_state := current_state
	current_state = new_state

	#ANCHOR:transition_match_current_state
	match current_state:
		#END:transition_match_current_state
		#ANCHOR:transition_enter_jump_head
		State.JUMP:
			#END:transition_enter_jump_head
			#ANCHOR:transition_enter_jump_velocity
			velocity.y = jump_speed
			current_gravity = jump_gravity
			#END:transition_enter_jump_velocity
			#END:transition_L06_code_ref_01
			#ANCHOR:transition_enter_jump_horizontal_speed
			velocity.x = direction_x * jump_horizontal_speed
			#END:transition_enter_jump_horizontal_speed
			#ANCHOR:transition_L06_code_ref_02
			#ANCHOR:transition_enter_jump_animation
			animated_sprite.play("Jump")
			#END:transition_enter_jump_animation

		#ANCHOR:transition_enter_fall_head
		State.FALL:
			#END:transition_enter_fall_head
			#ANCHOR:transition_enter_fall_gravity
			current_gravity = fall_gravity
			#END:transition_enter_fall_gravity
			#ANCHOR:transition_enter_fall_animation
			animated_sprite.play("Fall")
			#END:transition_enter_fall_animation
			#END:transition_L06_code_ref_02


## Calculates the maximum horizontal speed based on jump parameters
func calculate_jump_horizontal_speed(distance: float, time_to_peak: float, time_to_descent: float) -> float:
	return distance / (time_to_peak + time_to_descent)


## Calculates the initial jump velocity needed to reach a certain height
## Returns a negative value so you can directly apply it to velocity.y
func calculate_jump_speed(height: float, time_to_peak: float) -> float:
	return (-2.0 * height) / time_to_peak


## Calculates the gravity to apply while rising during a jump to reach the desired height
func calculate_jump_gravity(height: float, time_to_peak: float) -> float:
	return (2.0 * height) / pow(time_to_peak, 2.0)


## Calculates the gravity to apply while falling to get a consistent parabolic jump that matches the desired height
func calculate_fall_gravity(height: float, time_to_descent: float) -> float:
	return (2.0 * height) / pow(time_to_descent, 2.0)
