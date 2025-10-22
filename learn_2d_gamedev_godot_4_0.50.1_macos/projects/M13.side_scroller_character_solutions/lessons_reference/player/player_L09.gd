extends CharacterBody2D

#ANCHOR:L08_code_ref_01
#ANCHOR:states_head
enum State {
	GROUND,
	JUMP,
	#END:states_head
	#ANCHOR:states_double_jump
	DOUBLE_JUMP,
	#END:states_double_jump
	#ANCHOR:states_tail
	FALL
}
#END:states_tail

const MAX_JUMPS := 2

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
@export_range(50.0, 200.0) var jump_horizontal_distance := 80.0

@export_range(5.0, 50.0) var jump_cut_divider := 15.0

#ANCHOR:export_category_double_jump
@export_category("Double Jump")
#END:export_category_double_jump
@export_range(10.0, 200.0) var double_jump_height := 30.0
@export_range(0.1, 1.5) var double_jump_time_to_peak := 0.3
@export_range(0.1, 1.5) var double_jump_time_to_descent := 0.25

var direction_x := 0.0
var current_state: State = State.GROUND
var current_gravity := 0.0

# State-specific variables
var jump_count := 0

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
#END:L08_code_ref_01
@onready var dust: GPUParticles2D = %Dust
#ANCHOR:L08_code_ref_02
@onready var coyote_timer := Timer.new()

# Primary jump calculations
@onready var jump_speed := calculate_jump_speed(jump_height, jump_time_to_peak)
@onready var jump_gravity := calculate_jump_gravity(jump_height, jump_time_to_peak)
@onready var fall_gravity := calculate_fall_gravity(jump_height, jump_time_to_descent)
@onready var jump_horizontal_speed := calculate_jump_horizontal_speed(jump_horizontal_distance, jump_time_to_peak, jump_time_to_descent)

# Double jump calculations
@onready var double_jump_speed := calculate_jump_speed(double_jump_height, double_jump_time_to_peak)
@onready var double_jump_gravity := calculate_jump_gravity(double_jump_height, double_jump_time_to_peak)
@onready var double_jump_fall_gravity := calculate_fall_gravity(double_jump_height, double_jump_time_to_descent)


func _ready() -> void:
	#ANCHOR:_ready_transition_to_state
	_transition_to_state(current_state)
	#END:_ready_transition_to_state

	#ANCHOR:_ready_coyote_timer
	coyote_timer.wait_time = 0.1
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	#END:_ready_coyote_timer


func _physics_process(delta: float) -> void:
	#ANCHOR:physics_process_head
	direction_x = signf(Input.get_axis("move_left", "move_right"))

	match current_state:
		State.GROUND:
			process_ground_state(delta)
		State.JUMP:
			process_jump_state(delta)
		State.FALL:
			process_fall_state(delta)
			#END:physics_process_head
		#ANCHOR:physics_process_double_jump_state
		State.DOUBLE_JUMP:
			process_double_jump_state(delta)
			#END:physics_process_double_jump_state

	#ANCHOR:physics_process_tail
	velocity.y += current_gravity * delta
	velocity.y = minf(velocity.y, max_fall_speed)
	move_and_slide()
	#END:physics_process_tail


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


func process_ground_state(delta: float) -> void:
	#ANCHOR:process_ground_state_is_moving
	var is_moving := absf(direction_x) > 0.0
	#END:process_ground_state_is_moving
	if is_moving:
		velocity.x += acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)

		animated_sprite.flip_h = direction_x < 0.0
		animated_sprite.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
		animated_sprite.play("Idle")
		#END:L08_code_ref_02

	#ANCHOR:process_ground_state_dust
	dust.emitting = is_moving
	#END:process_ground_state_dust

	#ANCHOR:L08_code_ref_03
	if Input.is_action_just_pressed("jump"):
		_transition_to_state(State.JUMP)
	elif not is_on_floor():
		_transition_to_state(State.FALL)


func process_jump_state(delta: float) -> void:
	#ANCHOR:L08_process_jump_state_head
	if direction_x != 0.0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
		animated_sprite.flip_h = direction_x < 0.0

	if Input.is_action_just_released("jump"):
		var jump_cut_speed := jump_speed / jump_cut_divider
		if velocity.y < 0.0 and velocity.y < jump_cut_speed:
			velocity.y = jump_cut_speed

	if velocity.y >= 0.0:
		_transition_to_state(State.FALL)
		#END:L08_process_jump_state_head
	#ANCHOR:L08_process_jump_state_double_jump
	elif Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		_transition_to_state(State.DOUBLE_JUMP)
		#END:L08_process_jump_state_double_jump


func process_double_jump_state(delta: float) -> void:
	if direction_x != 0.0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
		animated_sprite.flip_h = direction_x < 0.0

	if velocity.y >= 0.0:
		_transition_to_state(State.FALL)


func process_fall_state(delta: float) -> void:
	#ANCHOR:L08_process_fall_state_head
	if direction_x != 0.0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
		animated_sprite.flip_h = direction_x < 0.0
		#END:L08_process_fall_state_head

	#ANCHOR:L08_process_fall_state_jump_input
	if Input.is_action_just_pressed("jump"):
		#END:L08_process_fall_state_jump_input
		#ANCHOR:L08_process_fall_state_coyote_jump
		if not coyote_timer.is_stopped():
			_transition_to_state(State.JUMP)
			#END:L08_process_fall_state_coyote_jump
		#ANCHOR:L08_process_fall_state_double_jump_elif
		elif jump_count < MAX_JUMPS:
			#END:L08_process_fall_state_double_jump_elif
			#ANCHOR:L08_process_fall_state_double_jump_transition
			_transition_to_state(State.DOUBLE_JUMP)
			#END:L08_process_fall_state_double_jump_transition

	#ANCHOR:L08_process_fall_state_ground_tail
	if is_on_floor():
		_transition_to_state(State.GROUND)
		#END:L08_process_fall_state_ground_tail


func _transition_to_state(new_state: State) -> void:
	#ANCHOR:L08_transition_to_state_head
	var previous_state := current_state
	current_state = new_state
	#END:L08_transition_to_state_head

	#ANCHOR:L08_transition_to_state_previous_fall
	match previous_state:
		State.FALL:
			coyote_timer.stop()
			#END:L08_transition_to_state_previous_fall

	#ANCHOR:L08_transition_to_state_match
	match current_state:
		#END:L08_transition_to_state_match
		#ANCHOR:L08_transition_to_state_enter_ground_head
		State.GROUND:
			jump_count = 0
			#END:L08_transition_to_state_enter_ground_head
			#END:L08_code_ref_03
			#ANCHOR:L08_transition_to_state_enter_ground_animation
			if previous_state == State.FALL:
				play_tween_touch_ground()
				#END:L08_transition_to_state_enter_ground_animation

		#ANCHOR:L08_code_ref_04
		#ANCHOR:L08_transition_to_state_jump
		State.JUMP:
			velocity.y = jump_speed
			current_gravity = jump_gravity
			velocity.x = direction_x * jump_horizontal_speed
			animated_sprite.play("Jump")
			#END:L08_transition_to_state_jump
			#ANCHOR:L08_transition_to_state_jump_count
			jump_count = 1
			#END:L08_transition_to_state_jump_count
			#END:L08_code_ref_04
			#ANCHOR:L08_transition_to_state_jump_tween
			play_tween_jump()
			#END:L08_transition_to_state_jump_tween
			#ANCHOR:L08_transition_to_state_jump_dust
			dust.emitting = true
			#END:L08_transition_to_state_jump_dust

		#ANCHOR:L08_code_ref_05
		#ANCHOR:L08_transition_to_state_double_jump
		State.DOUBLE_JUMP:
			velocity.y = double_jump_speed
			current_gravity = double_jump_gravity
			velocity.x = direction_x * jump_horizontal_speed
			animated_sprite.play("Jump")
			jump_count = MAX_JUMPS
			#END:L08_transition_to_state_double_jump
			#END:L08_code_ref_05
			#ANCHOR:L08_transition_to_state_double_jump_tween
			play_tween_jump()
			#END:L08_transition_to_state_double_jump_tween
			#ANCHOR:L08_transition_to_state_double_jump_dust
			dust.emitting = true
			#END:L08_transition_to_state_double_jump_dust

		#ANCHOR:L08_code_ref_06
		#ANCHOR:L08_transition_to_state_fall_head
		State.FALL:
			animated_sprite.play("Fall")
			#END:L08_transition_to_state_fall_head
			#ANCHOR:L08_transition_to_state_fall_gravity
			if jump_count == MAX_JUMPS:
				current_gravity = double_jump_fall_gravity
			else:
				current_gravity = fall_gravity
				#END:L08_transition_to_state_fall_gravity

			#ANCHOR:L08_transition_to_state_fall_coyote_timer
			if previous_state == State.GROUND:
				coyote_timer.start()
				#END:L08_transition_to_state_fall_coyote_timer
				#END:L08_code_ref_06


func play_tween_touch_ground() -> void:
	var tween := create_tween()
	tween.tween_property(animated_sprite, "scale", Vector2(1.1, 0.9), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2(0.9, 1.1), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2.ONE, 0.15)


func play_tween_jump() -> void:
	var tween := create_tween()
	tween.tween_property(animated_sprite, "scale", Vector2(1.15, 0.86), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2(0.86, 1.15), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2.ONE, 0.15)
