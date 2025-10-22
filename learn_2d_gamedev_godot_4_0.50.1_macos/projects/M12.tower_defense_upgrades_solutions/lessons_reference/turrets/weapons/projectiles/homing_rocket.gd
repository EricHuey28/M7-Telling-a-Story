## This rocket follows a target and turns towards it.
## It explodes and deals damage to the target when it reaches it.
class_name HomingRocket extends Rocket_2

var velocity := Vector2.ZERO
var drag_factor := 6.0
var target: Mob_2 = null

var _last_known_position := Vector2.ZERO

@onready var _homing_missile: Sprite2D = %HomingMissile
@onready var _smoke_trail_particles: GPUParticles2D = %SmokeTrailParticles
@onready var _missile_flame: Sprite2D = %MissileFlame


func _physics_process(delta: float) -> void:
	#ANCHOR: L08_update_last_known_position
	if target != null:
		_last_known_position = target.global_position
		#END: L08_update_last_known_position

	#ANCHOR: L08_steering
	var direction := global_position.direction_to(_last_known_position)
	var desired_velocity := speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor * delta
	position += velocity * delta
	rotation = velocity.angle()
	#END: L08_steering

	#ANCHOR: L08_distance_explode
	_traveled_distance += speed * delta
	if (
		_traveled_distance > max_distance or
		global_position.distance_to(_last_known_position) < 10.0
	):
		_explode()
		#END: L08_distance_explode

	_missile_flame.scale = Vector2.ONE * (abs(sin(Time.get_ticks_msec() / 80.0)) / 4.0 + 0.5)


func _explode() -> void:
	var explosion: Node2D = preload("../explosion/explosion.tscn").instantiate()
	explosion.damage = damage
	get_tree().current_scene.add_child.call_deferred(explosion)
	explosion.global_position = global_position

	set_deferred("monitoring", false)
	set_physics_process(false)
	_homing_missile.hide()
	_smoke_trail_particles.emitting = false
	_missile_flame.hide()

	get_tree().create_timer(0.5).timeout.connect(queue_free)


func _on_area_entered(other_area: Area2D) -> void:
	_explode()
