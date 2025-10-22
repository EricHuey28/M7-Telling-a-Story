#ANCHOR:extends
class_name Player extends CharacterBody2D
#END:extends

#ANCHOR:l4_01
@export var speed := 460.0
@export var ground_friction_factor := 10.0
#END:l4_01
#ANCHOR:l10_01
@export var max_health := 5

@onready var health := max_health: set = set_health

@onready var _health_bar: ProgressBar = %HealthBar
@onready var _collision_shape_2d: CollisionShape2D = %CollisionShape2D
#END:l10_01
@onready var _damage_audio: AudioStreamPlayer2D = %DamageAudio
@onready var _die_audio: AudioStreamPlayer2D = %DieAudio


#ANCHOR:l10_02
func _ready() -> void:
	_health_bar.max_value = max_health
	_health_bar.value = health
	#END:l10_02


#ANCHOR:l4_02
func _physics_process(delta: float) -> void:
	var move_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var desired_velocity := speed * move_direction
	var steering := desired_velocity - velocity
	velocity += steering * ground_friction_factor * delta
	move_and_slide()
#END:l4_02


func set_health(new_health: int) -> void:
	var previous_health := health
	#ANCHOR:l10_03
	health = clampi(new_health, 0, max_health)
	_health_bar.value = health

	if health == 0:
		die()
	#END:l10_03
	elif previous_health > health:
		_damage_audio.play()


#ANCHOR:die_definition
func die() -> void:
	#END:die_definition
	set_physics_process(false)
	_collision_shape_2d.set_deferred("disabled", true)
	_die_audio.play()
	_die_audio.finished.connect(
		get_tree().reload_current_scene
	)
