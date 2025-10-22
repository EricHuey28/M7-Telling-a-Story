#ANCHOR:header
extends CharacterBody2D

## The top speed that the runner can achieve
@export var max_speed := 600.0
## How much speed is added per second when the player presses a movement key
@export var acceleration := 1200.0
#END:header

#ANCHOR:nodes
@onready var _dust: GPUParticles2D = %Dust
@onready var _runner_visual: RunnerVisual = %RunnerVisualPurple
#END:nodes

#ANCHOR:physics_process_signature
func _physics_process(delta: float) -> void:
	#END:physics_process_signature
	#ANCHOR:direction
	var direction := global_position.direction_to(get_global_mouse_position())
	#END:direction
	#ANCHOR:distance
	var distance := global_position.distance_to(get_global_mouse_position())
	#END:distance
	#ANCHOR:speed
	var speed := max_speed if distance > 100 else max_speed * distance / 100
	#END:speed

	#ANCHOR:desired_velocity
	var desired_velocity := direction * speed
	#END:desired_velocity

	#ANCHOR:velocity
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	#END:velocity
	move_and_slide()

	#ANCHOR:velocity_check
	if velocity.length() > 10.0:
		#END:velocity_check
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)

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
