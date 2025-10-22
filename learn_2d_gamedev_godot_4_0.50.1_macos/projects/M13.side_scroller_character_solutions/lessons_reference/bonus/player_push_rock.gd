class_name Player extends CharacterBody2D

enum State {
	GROUND,
	JUMP,
	FALL,
	PUSH
}

@export var acceleration := 700.0
@export var deceleration := 1400.0
@export var max_fall_speed := 320.0

@export var jump_horizontal_distance := 80.0
@export var jump_height := 50.0
@export var jump_time_to_peak := 0.37
@export var jump_time_to_descent := 0.25
@export var jump_cut_divider := 15.0

var direction_x := 0.0
var current_state: State = State.GROUND
var current_gravity := 0.0

# State-specific variables
var coyote_time_active := false

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var coyote_timer := Timer.new()

@onready var max_speed := calculate_max_speed(jump_horizontal_distance, jump_time_to_peak, jump_time_to_descent)
@onready var jump_speed := calculate_jump_speed(jump_height, jump_time_to_peak)
@onready var jump_gravity := calculate_jump_gravity(jump_height, jump_time_to_peak)
@onready var fall_gravity := calculate_fall_gravity(jump_height, jump_time_to_descent)


func _ready() -> void:
	_transition_to_state(current_state)

	coyote_timer.wait_time = 0.1
	coyote_timer.one_shot = true
	coyote_timer.timeout.connect(_on_coyote_timer_timeout)
	add_child(coyote_timer)


func _physics_process(delta: float) -> void:
	direction_x = signf(Input.get_axis("move_left", "move_right"))

	match current_state:
		State.GROUND:
			process_ground_state(delta)
		State.JUMP:
			process_jump_state(delta)
		State.FALL:
			process_fall_state(delta)
		State.PUSH:
			process_push_state(delta)

	velocity.y += current_gravity * delta
	velocity.y = minf(velocity.y, max_fall_speed)
	move_and_slide()

	# Mob interactions: here we handle both stomping and getting hit
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var mob := collision.get_collider() as Mob
		if mob == null or mob.is_dead:
			continue

		var normal := collision.get_normal()
		var is_above_mob := signf(normal.y) == -1.0
		if is_above_mob:
			mob.die()
			_transition_to_state(State.JUMP)
			break
		else:
			# The player got hit by a mob, this is where you'd transition to a
			# hurt or die state.
			print("Player hit by mob!")
			queue_free()


## Calculates the maximum horizontal speed based on jump parameters
func calculate_max_speed(distance: float, time_to_peak: float, time_to_descent: float) -> float:
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
	var is_moving := absf(direction_x) > 0.0
	if is_moving:
		if check_and_push_rock():
			_transition_to_state(State.PUSH)
			return

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
	if is_on_ceiling():
		velocity.y = 0.0

	if is_on_floor():
		_transition_to_state(State.GROUND)
	elif velocity.y >= 0.0:
		_transition_to_state(State.FALL)

	if direction_x != 0.0:
		velocity.x += acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		animated_sprite.flip_h = direction_x < 0.0

	if Input.is_action_just_released("jump"):
		var jump_cut_speed := jump_speed / jump_cut_divider
		if velocity.y < 0.0 and velocity.y < jump_cut_speed:
			velocity.y = jump_cut_speed


func process_fall_state(delta: float) -> void:
	if is_on_floor():
		_transition_to_state(State.GROUND)
		return

	if direction_x != 0.0:
		velocity.x += acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		animated_sprite.flip_h = direction_x < 0.0

	if Input.is_action_just_pressed("jump") and coyote_time_active:
		_transition_to_state(State.JUMP)


func process_push_state(delta: float) -> void:
	var is_moving := absf(direction_x) > 0.0
	if is_moving:
		if check_and_push_rock():
			animated_sprite.play("Push")
		else:
			_transition_to_state(State.GROUND)
	else:
		_transition_to_state(State.GROUND)

	if not is_on_floor():
		_transition_to_state(State.FALL)
	elif Input.is_action_just_pressed("jump"):
		_transition_to_state(State.JUMP)


func _transition_to_state(new_state: State) -> void:
	var previous_state := current_state
	current_state = new_state

	# Exit previous state
	match previous_state:
		State.FALL:
			coyote_time_active = false
			coyote_timer.stop()

	# Enter new state
	match current_state:
		State.GROUND:
			current_gravity = fall_gravity
			if previous_state == State.FALL:
				play_tween_touch_ground()

		State.JUMP:
			velocity.y = jump_speed
			current_gravity = jump_gravity
			animated_sprite.play("Jump")
			play_tween_jump()

		State.FALL:
			current_gravity = fall_gravity
			animated_sprite.play("Fall")

			if previous_state == State.GROUND:
				coyote_time_active = true
				coyote_timer.start()

		State.PUSH:
			current_gravity = fall_gravity


func _on_coyote_timer_timeout() -> void:
	coyote_time_active = false


func play_tween_touch_ground() -> void:
	var tween := create_tween()
	tween.tween_property(animated_sprite, "scale", Vector2(1.1, 0.9), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2(0.9, 1.1), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2.ONE, 0.15)


func play_tween_jump() -> void:
	var tween := create_tween()
	tween.tween_property(animated_sprite, "scale", Vector2(1.2, 0.8), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2(0.8, 1.2), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2.ONE, 0.15)


func check_and_push_rock() -> bool:
	for i in get_slide_collision_count():
		var collision_data := get_slide_collision(i)
		var collider := collision_data.get_collider() as Rock
		if collider == null:
			continue
		var normal := collision_data.get_normal()
		if normal.abs() != Vector2(1.0, 0.0):
			continue
		var push_force = -1.0 * collision_data.get_normal().x * 40.0
		collider.velocity.x = push_force
		velocity.x = push_force
		return true
	return false
