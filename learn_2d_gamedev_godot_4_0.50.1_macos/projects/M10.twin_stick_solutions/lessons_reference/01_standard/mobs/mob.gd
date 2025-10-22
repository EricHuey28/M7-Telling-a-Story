## Base class for enemies. Defines some functions you can reuse to create
## different kinds of enemies.
#ANCHOR:l07_01
class_name Mob extends CharacterBody2D

@export var max_speed := 250.0
@export var acceleration := 700.0
#END:l07_01
#ANCHOR:l09_01
@export var health := 3: set = set_health
#END:l09_01
#ANCHOR:damage_definition
@export var damage := 1
#END:damage_definition

#ANCHOR:l07_02
var _player: Player = null

@onready var _detection_area: Area2D = %DetectionArea
#END:l07_02
#ANCHOR:l10_01
@onready var _hit_box: Area2D = %HitBox
#END:l10_01

@onready var _hurt_sound: AudioStreamPlayer = %HurtSound
@onready var _die_sound: AudioStreamPlayer = %DieSound


func _ready() -> void:
	#ANCHOR:l07_03
	_detection_area.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			_player = body
	)
	_detection_area.body_exited.connect(func (body: Node) -> void:
		if body is Player:
			_player = null
	)
	#END:l07_03

	#ANCHOR:l10_02
	_hit_box.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			body.health -= damage
	)
	#END:l10_02


#ANCHOR:set_health_definition
func set_health(new_health: int) -> void:
	#END:set_health_definition
	var previous_health := health

	#ANCHOR:l09_04
	health = new_health
	if health <= 0:
		die()
		#END:l09_04
	elif health < previous_health:
		_hurt_sound.play()


#ANCHOR:die_definition
func die() -> void:
	#END:die_definition
	if _hit_box == null:
		return
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0
	_hit_box.queue_free()

	_die_sound.play()
	_die_sound.finished.connect(queue_free)


#ANCHOR:l07_04
func _physics_process(delta: float) -> void:
	if _player == null:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	else:
		var direction := global_position.direction_to(_player.global_position)
		var distance := global_position.distance_to(_player.global_position)
		var speed := max_speed if distance > 120.0 else max_speed * distance / 120.0
		var desired_velocity := direction * speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)

	move_and_slide()
	#END:l07_04
