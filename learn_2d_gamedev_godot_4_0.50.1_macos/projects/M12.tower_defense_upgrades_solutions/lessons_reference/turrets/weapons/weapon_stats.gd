class_name WeaponStats_2 extends Resource

@export_range(80.0, 1000.0) var mob_detection_radius := 200.0: set = set_mob_detection_radius
@export_range(0.1, 10.0) var attack_rate := 1.0: set = set_attack_rate
@export var damage := 10.0
@export var max_rotation_speed := 2.0 * PI


func set_mob_detection_radius(new_radius: float) -> void:
	mob_detection_radius = new_radius
	emit_changed()


func set_attack_rate(new_rate: float) -> void:
	attack_rate = maxf(new_rate, 0.1)
	emit_changed()
