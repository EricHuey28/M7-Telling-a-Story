#ANCHOR: l4_head
class_name TurretUpgrade_2 extends Resource

@export var cost := 100

@export_group("Upgrades")
@export var mob_detection_radius_change := 0.0
@export var attack_rate_change := 0.0
@export var damage_change := 0.0
@export var replacement_weapon: PackedScene = null
#END: l4_head


func apply_to_turret(turret: Turret_2) -> void:
	turret.level += 1
	turret.weapon.stats.mob_detection_radius += mob_detection_radius_change
	turret.weapon.stats.attack_rate += attack_rate_change
	turret.weapon.stats.damage += damage_change

	if replacement_weapon != null:
		turret.set_weapon_scene(replacement_weapon)
