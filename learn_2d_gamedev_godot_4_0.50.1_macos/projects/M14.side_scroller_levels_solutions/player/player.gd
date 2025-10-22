class_name Player extends CharacterBody2D

const EXPLOSION = preload("uid://bfuki5y2411xs")

enum States {
	SPAWN,
	GROUND,
	JUMP,
	FALL,
	PUSH,
	DIE,
	DOUBLE_JUMP
}

const MAX_JUMPS := 2

@export var acceleration := 700.0
@export var deceleration := 1400.0
@export var max_fall_speed := 320.0

@export var jump_horizontal_distance := 80.0
@export var jump_height := 50.0
@export var jump_time_to_peak := 0.37
@export var jump_time_to_descent := 0.25
@export var jump_cut_divider := 15.0

@export var double_jump_height := 30.0
@export var double_jump_time_to_peak := 0.3
@export var double_jump_time_to_descent := 0.25

var direction_x := 0.0
var current_state: States = States.SPAWN
var current_gravity := 0.0

# States-specific variables
var coyote_time_active := false
var jump_count := 0

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var dust: GPUParticles2D = %Dust
@onready var coyote_timer := Timer.new()

@onready var max_speed := calculate_max_speed(jump_horizontal_distance, jump_time_to_peak, jump_time_to_descent)
@onready var jump_speed := calculate_jump_speed(jump_height, jump_time_to_peak)
@onready var jump_gravity := calculate_jump_gravity(jump_height, jump_time_to_peak)
@onready var fall_gravity := calculate_fall_gravity(jump_height, jump_time_to_descent)

# Double jump calculations
@onready var double_jump_speed := calculate_jump_speed(double_jump_height, double_jump_time_to_peak)
@onready var double_jump_gravity := calculate_jump_gravity(double_jump_height, double_jump_time_to_peak)
@onready var double_jump_fall_gravity := calculate_fall_gravity(double_jump_height, double_jump_time_to_descent)

@onready var respawn_position: Vector2 = global_position


func _ready() -> void:
	_transition_to_state(current_state)

	coyote_timer.wait_time = 0.1
	coyote_timer.one_shot = true
	coyote_timer.timeout.connect(_on_coyote_timer_timeout)
	add_child(coyote_timer)


func _physics_process(delta: float) -> void:
	direction_x = signf(Input.get_axis("move_left", "move_right"))

	match current_state:
		States.SPAWN:
			pass
		States.GROUND:
			process_ground_state(delta)
		States.JUMP:
			process_jump_state(delta)
		States.FALL:
			process_fall_state(delta)
		States.PUSH:
			process_push_state(delta)
		States.DOUBLE_JUMP:
			process_double_jump_state(delta)
		States.DIE:
			pass

	velocity.y += current_gravity * delta
	velocity.y = minf(velocity.y, max_fall_speed)
	move_and_slide()

	if current_state not in [States.DIE, States.SPAWN]:
		_handle_mob_interactions()


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
			_transition_to_state(States.PUSH)
			return

		velocity.x += acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)

		animated_sprite.flip_h = direction_x < 0.0
		animated_sprite.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
		animated_sprite.play("Idle")

	dust.emitting = absf(direction_x) > 0.0

	if Input.is_action_just_pressed("jump"):
		_transition_to_state(States.JUMP)
	elif not is_on_floor():
		_transition_to_state(States.FALL)


func process_jump_state(delta: float) -> void:
	if is_on_ceiling():
		velocity.y = 0.0

	if is_on_floor():
		_transition_to_state(States.GROUND)
	elif velocity.y >= 0.0:
		_transition_to_state(States.FALL)

	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		_transition_to_state(States.DOUBLE_JUMP)
	elif Input.is_action_just_released("jump"):
		var jump_cut_speed := jump_speed / jump_cut_divider
		if velocity.y < 0.0 and velocity.y < jump_cut_speed:
			velocity.y = jump_cut_speed

	if direction_x != 0.0:
		velocity.x += acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		animated_sprite.flip_h = direction_x < 0.0


func process_fall_state(delta: float) -> void:
	if is_on_floor():
		_transition_to_state(States.GROUND)
		return

	if direction_x != 0.0:
		velocity.x += acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		animated_sprite.flip_h = direction_x < 0.0

	if Input.is_action_just_pressed("jump"):
		if coyote_time_active:
			_transition_to_state(States.JUMP)
		elif jump_count < MAX_JUMPS:
			_transition_to_state(States.DOUBLE_JUMP)


func process_push_state(delta: float) -> void:
	var is_moving := absf(direction_x) > 0.0
	if is_moving:
		if check_and_push_rock():
			animated_sprite.play("Push")
		else:
			_transition_to_state(States.GROUND)
	else:
		_transition_to_state(States.GROUND)

	if not is_on_floor():
		_transition_to_state(States.FALL)
	elif Input.is_action_just_pressed("jump"):
		_transition_to_state(States.JUMP)


func _transition_to_state(new_state: States) -> void:
	var previous_state := current_state
	current_state = new_state

	# Exit previous state
	match previous_state:
		States.FALL:
			coyote_time_active = false
			coyote_timer.stop()

	# Enter new state
	match current_state:
		States.SPAWN:
			animated_sprite.play("Idle")
			get_tree().create_timer(0.1).timeout.connect(
				func ():
					set_physics_process(true)
					_transition_to_state(States.FALL)
			)

		States.GROUND:
			current_gravity = fall_gravity
			if previous_state == States.FALL:
				play_tween_touch_ground()
				jump_count = 0

		States.JUMP:
			velocity.y = jump_speed
			current_gravity = jump_gravity
			animated_sprite.play("Jump")
			jump_count = 1
			dust.emitting = true

		States.DOUBLE_JUMP:
			velocity.y = double_jump_speed
			current_gravity = double_jump_gravity
			animated_sprite.play("Jump")
			jump_count = MAX_JUMPS
			play_tween_jump()

		States.FALL:
			current_gravity = fall_gravity
			animated_sprite.play("Fall")

			if previous_state == States.GROUND:
				coyote_time_active = true
				coyote_timer.start()

		States.PUSH:
			current_gravity = fall_gravity

		States.DIE:
			velocity = Vector2.ZERO
			set_physics_process(false)
			animated_sprite.play("Die")
			dust.emitting = false
			var explosion: Node2D = EXPLOSION.instantiate()
			add_child(explosion)
			explosion.global_position = collision_shape_2d.global_position
			get_tree().create_timer(1.0).timeout.connect(respawn)


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


func process_double_jump_state(delta: float) -> void:
	if direction_x != 0.0:
		velocity.x += acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		animated_sprite.flip_h = direction_x < 0.0

	if velocity.y >= 0.0:
		_transition_to_state(States.FALL)


## Handles all interactions with mobs, both stomping and getting hit
func _handle_mob_interactions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var mob := collision.get_collider() as Mob
		if mob == null or mob.is_dead:
			continue

		var normal := collision.get_normal()
		var is_above_mob := signf(normal.y) == -1.0
		if is_above_mob:
			mob.die()
			_transition_to_state(States.JUMP)
		else:
			die()


func die() -> void:
	if current_state not in [States.SPAWN, States.DIE]:
		_transition_to_state(States.DIE)


func respawn() -> void:
	global_position = respawn_position
	jump_count = 0
	coyote_time_active = false
	_transition_to_state(States.SPAWN)


func deactivate() -> void:
	animated_sprite.play("Idle")
	set_physics_process(false)
