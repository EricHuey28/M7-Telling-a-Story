## Base class for weapons. It provides functions and nodes that weapons can use.
## Different weapons will act differently, so you need to extend this class to
## create a functional weapon. For example, not all weapons will shoot bullets,
## target and rotate toward mobs in the same way, or deal damage. A weapon may
## slow down mobs, apply status effects, or boost surrounding turrets.
##
## That's why this class doesn't provide default behavior or variables to track
## a current target.
class_name Weapon_2 extends Sprite2D

var stats := WeaponStats_2.new(): set = _set_stats

var _area_2d := _create_area_2d()
var _collision_shape_2d := _create_collision_shape_2d()
var _timer := _create_timer()


func _ready() -> void:
	#ANCHOR: l4_ready_head
	add_child(_area_2d)
	_area_2d.add_child(_collision_shape_2d)

	add_child(_timer)
	_timer.start()
	_timer.timeout.connect(_attack)

	z_index = 10
	#END: l4_ready_head

	#ANCHOR: l4_ready_update_stats
	_set_stats(stats)
	_update_from_stats()
	#END: l4_ready_update_stats


func _create_area_2d() -> Area2D:
	var area := Area2D.new()
	area.monitoring = true
	area.monitorable = false
	return area


func _create_collision_shape_2d() -> CollisionShape2D:
	var collision_shape := CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	return collision_shape


func _create_timer() -> Timer:
	var timer := Timer.new()
	return timer


func _set_stats(new_stats: WeaponStats_2) -> void:
	if stats != null:
		if stats.changed.is_connected(_update_from_stats):
			stats.changed.disconnect(_update_from_stats)

	stats = new_stats
	if stats != null:
		stats.changed.connect(_update_from_stats)


## Called when the stats of the turret change. Override this method to update
## the weapon's behavior.
func _update_from_stats() -> void:
	_timer.wait_time = 1.0 / stats.attack_rate
	_collision_shape_2d.shape.radius = stats.mob_detection_radius


## Virtual method. Called when it's time to attack.
func _attack() -> void:
	return


## The weapon does not detect mobs directly, as mobs themselves are not physics nodes. Instead, it detects their hurtbox.
## That's why the function looks for and returns an Area2D.
func _find_closest_target() -> Mob_2:
	var targets := _area_2d.get_overlapping_areas()

	var closest_target: Mob_2 = null
	var smallest_distance := INF
	for target: Area2D in targets:
		var distance_to_target := global_position.distance_to(target.global_position)
		if distance_to_target < smallest_distance:
			smallest_distance = distance_to_target
			closest_target = target as Mob_2

	return closest_target
