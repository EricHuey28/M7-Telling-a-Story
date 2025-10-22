# This script is a copy of the character with a single jump and the kinematic
# jump formulas implemented. It adds wall slide and jump mechanics instead of
# the double jump.
#
# We detect the wall thanks to two ray casts that stick out of the character on
# either side which you can find in the character scene.
extends CharacterBody2D

enum State {
	GROUND,
	JUMP,
	FALL,
	# I added two states to respectively handle when the character is against
	# the wall sliding down and to perform a wall jump which has some
	# differences with a regular jump.
	WALL_SLIDE,
	WALL_JUMP
}

@export var acceleration := 700.0
@export var deceleration := 1400.0
@export var max_speed := 120.0
@export var air_acceleration := 500.0
@export var max_fall_speed := 250.0

@export_category("Jump")
@export_range(10.0, 200.0) var jump_height := 50.0
@export_range(0.1, 1.5) var jump_time_to_peak := 0.37
@export_range(0.1, 1.5) var jump_time_to_descent := 0.2
@export_range(50.0, 200.0) var jump_horizontal_distance := 80.0
@export_range(5.0, 50.0) var jump_cut_divider := 15.0

# Just like the double jump the wall jump has its set of properties to make it a
# bit more horizontal than the regular jump and to control how the
# character slides against the wall.
@export_category("Wall Jump")
@export_range(10.0, 100.0) var wall_jump_height := 30.0
@export_range(80.0, 200.0) var wall_jump_horizontal_distance := 120.0
@export var wall_slide_speed := 50.0
@export var wall_slide_friction := 300.0
@export_range(0.05, 0.3) var wall_slide_grace_time := 0.1

var current_state: State = State.GROUND
var direction_x := 0.0
var current_gravity := 0.0
var wall_slide_grace_timer := 0.0

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

@onready var jump_speed := calculate_jump_speed(jump_height, jump_time_to_peak)
@onready var jump_gravity := calculate_jump_gravity(jump_height, jump_time_to_peak)
@onready var fall_gravity := calculate_fall_gravity(jump_height, jump_time_to_descent)
@onready var jump_horizontal_speed := calculate_jump_horizontal_speed(jump_horizontal_distance, jump_time_to_peak, jump_time_to_descent)

@onready var wall_jump_speed := calculate_jump_speed(wall_jump_height, jump_time_to_peak)
@onready var wall_jump_horizontal_speed := calculate_jump_horizontal_speed(wall_jump_horizontal_distance, jump_time_to_peak, jump_time_to_descent)

@onready var wall_raycast_left: RayCast2D = $WallRaycastLeft
@onready var wall_raycast_right: RayCast2D = $WallRaycastRight


func _ready() -> void:
	_transition_to_state(current_state)


func _physics_process(delta: float) -> void:
	direction_x = signf(Input.get_axis("move_left", "move_right"))

	match current_state:
		State.GROUND:
			process_ground_state(delta)
		State.JUMP:
			process_jump_state(delta)
		State.FALL:
			process_fall_state(delta)
		State.WALL_SLIDE:
			process_wall_slide_state(delta)
		State.WALL_JUMP:
			process_wall_jump_state(delta)

	velocity.y += current_gravity * delta
	velocity.y = minf(velocity.y, max_fall_speed)
	move_and_slide()


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
	if direction_x != 0.0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
		animated_sprite.flip_h = direction_x < 0.0

	if Input.is_action_just_released("jump"):
		var jump_cut_speed := jump_speed / jump_cut_divider
		if velocity.y < 0.0 and velocity.y < jump_cut_speed:
			velocity.y = jump_cut_speed

	if is_against_wall() and direction_x == get_wall_direction():
		_transition_to_state(State.WALL_SLIDE)
	elif velocity.y >= 0.0:
		_transition_to_state(State.FALL)


func process_fall_state(delta: float) -> void:
	if direction_x != 0.0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
		animated_sprite.flip_h = direction_x < 0.0

	if is_against_wall() and direction_x == get_wall_direction():
		_transition_to_state(State.WALL_SLIDE)
	elif is_on_floor():
		_transition_to_state(State.GROUND)


func process_wall_slide_state(delta: float) -> void:
	# When against a wall we still apply gravity but counteract it with friction
	# that slows down the character going up or down the wall. This gives the
	# player a bit more time to react and jump off the wall.
	if velocity.y > 0.0:
		velocity.y = move_toward(velocity.y, 0.0, wall_slide_friction * delta)
		velocity.y = clampf(velocity.y, 0.0, wall_slide_speed)
	else:
		velocity.y = move_toward(velocity.y, 0.0, wall_slide_friction * delta)

	if is_on_floor():
		_transition_to_state(State.GROUND)
	elif Input.is_action_just_pressed("jump"):
		_transition_to_state(State.WALL_JUMP)
	# When the player tries to go in the direction away from the wall, we don't
	# want them to fall immediately. We want them to still stick for just enough
	# time to jump. So we give them a grace period.
	elif not (is_against_wall() and signf(direction_x) == get_wall_direction()):
		if wall_slide_grace_timer <= 0.0:
			wall_slide_grace_timer = wall_slide_grace_time

		wall_slide_grace_timer -= delta

		if wall_slide_grace_timer <= 0.0:
			_transition_to_state(State.FALL)
	else:
		wall_slide_grace_timer = 0.0


func process_wall_jump_state(delta: float) -> void:
	# The update function for the wall jump has much of the same code as the
	# regular jump.
	if direction_x != 0.0:
		velocity.x += air_acceleration * direction_x * delta
		animated_sprite.flip_h = direction_x < 0.0

	velocity.x = clampf(velocity.x, -wall_jump_horizontal_speed, wall_jump_horizontal_speed)

	if velocity.y >= 0.0:
		_transition_to_state(State.FALL)


func _transition_to_state(new_state: State) -> void:
	var previous_state := current_state
	current_state = new_state

	match current_state:
		State.JUMP:
			velocity.y = jump_speed
			current_gravity = jump_gravity
			velocity.x = direction_x * jump_horizontal_speed
			animated_sprite.play("Jump")

		State.FALL:
			current_gravity = fall_gravity
			animated_sprite.play("Fall")

		State.WALL_SLIDE:
			current_gravity = fall_gravity
			animated_sprite.play("Fall")
			animated_sprite.flip_h = get_wall_direction() < 0.0
			wall_slide_grace_timer = 0.0

		State.WALL_JUMP:
			velocity.y = wall_jump_speed
			current_gravity = jump_gravity
			var wall_direction := get_wall_direction()
			velocity.x = -wall_direction * wall_jump_horizontal_speed
			# This line makes the character initially face in the direction of
			# the jump so they don't look at the wall (Unless the player is
			# pressing the direction key towards the wall)
			animated_sprite.flip_h = velocity.x < 0.0
			animated_sprite.play("Jump")


func is_against_wall() -> bool:
	return wall_raycast_left.is_colliding() or wall_raycast_right.is_colliding()


func get_wall_direction() -> float:
	if wall_raycast_left.is_colliding():
		return -1.0
	elif wall_raycast_right.is_colliding():
		return 1.0
	return 0.0


func calculate_jump_horizontal_speed(distance: float, time_to_peak: float, time_to_descent: float) -> float:
	return distance / (time_to_peak + time_to_descent)


func calculate_jump_speed(height: float, time_to_peak: float) -> float:
	return (-2.0 * height) / time_to_peak


func calculate_jump_gravity(height: float, time_to_peak: float) -> float:
	return (2.0 * height) / pow(time_to_peak, 2.0)


func calculate_fall_gravity(height: float, time_to_descent: float) -> float:
	return (2.0 * height) / pow(time_to_descent, 2.0)
