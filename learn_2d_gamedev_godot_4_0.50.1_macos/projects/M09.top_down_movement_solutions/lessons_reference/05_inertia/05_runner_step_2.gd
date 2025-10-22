#ANCHOR:file_header
extends CharacterBody2D

## The top speed that the runner can achieve
@export var max_speed := 600.0
## How much speed is added per second when the player presses a movement key
@export var acceleration := 1200.0
## How much speed is lost per second when the player releases all movement keys
#ANCHOR:var_deceleration
@export var deceleration := 1080.0
#END:var_deceleration
#END:file_header

#ANCHOR:character_visual
@onready var _runner_visual: RunnerVisual = %RunnerVisualRed
#END:character_visual

#ANCHOR:physics_process_definition
func _physics_process(delta: float) -> void:
#END:physics_process_definition
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var has_input_direction := direction.length() > 0.0
	#ANCHOR:movement
	if has_input_direction:
		var desired_velocity := direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	#END:movement

	#ANCHOR:move_and_slide
	move_and_slide()
	#END:move_and_slide

	#ANCHOR:if_direction
	if direction.length() > 0.0:
		#END:if_direction
		#ANCHOR:rotate_toward
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)
		#END:rotate_toward
		#ANCHOR:speed_percent
		var current_speed_percent := velocity.length() / max_speed
		#END:speed_percent
		#ANCHOR:set_animation_running
		_runner_visual.animation_name = (
			RunnerVisual.Animations.WALK
			if current_speed_percent < 0.8
			else RunnerVisual.Animations.RUN
		)
		#END:set_animation_running
	#ANCHOR:set_animation_idle
	else:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		#END:set_animation_idle
