extends CharacterBody2D

## The top speed that the runner can achieve
@export var max_speed := 600.0
## How much speed is added per second when the player presses a movement key
@export var acceleration := 1200.0

@onready var _dust: GPUParticles2D = %Dust
@onready var _runner_visual: RunnerVisual = %RunnerVisualPurple

#ANCHOR:hit_box
@onready var _hit_box: Area2D = %HitBox
#END:hit_box


func _ready() -> void:
	#ANCHOR:connect_hit_box
	_hit_box.body_entered.connect(func(body: Node) -> void:
		if body is Runner:
			get_tree().reload_current_scene.call_deferred()
	)
	#END:connect_hit_box


func _physics_process(delta: float) -> void:
	#ANCHOR:use_player_position
	var direction := global_position.direction_to(get_global_player_position())
	var distance := global_position.distance_to(get_global_player_position())
	#END:use_player_position
	var speed := max_speed if distance > 100 else max_speed * distance / 100

	var desired_velocity := direction * speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()

	if velocity.length() > 10.0:
		var angle := rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)
		_runner_visual.angle = angle

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


#ANCHOR:get_global_player_position
func get_global_player_position() -> Vector2:
	return get_tree().root.get_node("Game/Runner").global_position
	#END:get_global_player_position
