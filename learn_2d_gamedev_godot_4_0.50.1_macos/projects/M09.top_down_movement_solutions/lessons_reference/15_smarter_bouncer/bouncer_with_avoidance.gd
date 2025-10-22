extends CharacterBody2D

## The top speed that the runner can achieve
@export var max_speed := 600.0
## How much speed is added per second when the player presses a movement key
@export var acceleration := 1200.0
#ANCHOR:avoidance_strength
@export var avoidance_strength := 21000.0
#END:avoidance_strength

@onready var _dust: GPUParticles2D = %Dust
@onready var _runner_visual: RunnerVisual = %RunnerVisualPurple
@onready var _hit_box: Area2D = %HitBox
#ANCHOR:raycast_nodes
@onready var _raycasts: Node2D = %Raycasts
#END:raycast_nodes


func _ready() -> void:
	_hit_box.body_entered.connect(func(body: Node) -> void:
		if body is Runner:
			get_tree().reload_current_scene.call_deferred()
	)
#ANCHOR:raycast_exceptions
	for raycast: RayCast2D in _raycasts.get_children():
		raycast.add_exception(self)
#END:raycast_exceptions


#ANCHOR:physics_process_definition
func _physics_process(delta: float) -> void:
	#END:physics_process_definition
	var direction := global_position.direction_to(get_global_player_position())
	var distance := global_position.distance_to(get_global_player_position())
	var speed := max_speed if distance > 100 else max_speed * distance / 100

	#ANCHOR:desired_velocity
	var desired_velocity := direction * speed
	#END:desired_velocity
	#ANCHOR:avoid_velocity
	desired_velocity += calculate_avoidance_force() * delta
	#END:avoid_velocity

	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()

	#ANCHOR:velocity_rotation
	if velocity.length() > 10.0:
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)
		#END:velocity_rotation
		#ANCHOR:raycasts_rotation
		_raycasts.rotation = _runner_visual.angle
		#END:raycasts_rotation

		var current_speed_percent := velocity.length() / max_speed
		_runner_visual.animation_name = (
			RunnerVisual.Animations.WALK
			if current_speed_percent < 0.8
			else RunnerVisual.Animations.RUN
		)

		_dust.emitting = true
	else:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		_dust.emitting = false


func get_global_player_position() -> Vector2:
	return get_tree().root.get_node("Game/Runner").global_position


## Returns a vector that represents the direction to avoid obstacles
#ANCHOR:calculate_avoidance_force
#ANCHOR:calculate_avoidance_force_definition
func calculate_avoidance_force() -> Vector2:
	#END:calculate_avoidance_force_definition
	#ANCHOR:avoidance_force_and_loop
	var avoidance_force := Vector2.ZERO

	for raycast: RayCast2D in _raycasts.get_children():
		if raycast.is_colliding():
			#END:avoidance_force_and_loop
			#ANCHOR:collision_position_direction
			var collision_position := raycast.get_collision_point()
			var direction_away_from_obstacle := collision_position.direction_to(raycast.global_position)
			#END:collision_position_direction

			# The more the raycast is into the obstacle, the more we want to push away from the obstacle.
			#ANCHOR:calculate_scaled_force
			var ray_length := raycast.target_position.length()
			var intensity := 1.0 - collision_position.distance_to(raycast.global_position) / ray_length

			var force := direction_away_from_obstacle * avoidance_strength * intensity
			#END:calculate_scaled_force
			#ANCHOR:add_avoidance_force
			avoidance_force += force
			#END:add_avoidance_force

	#ANCHOR:return_avoidance_force
	return avoidance_force
	#END:return_avoidance_force
#END:calculate_avoidance_force
