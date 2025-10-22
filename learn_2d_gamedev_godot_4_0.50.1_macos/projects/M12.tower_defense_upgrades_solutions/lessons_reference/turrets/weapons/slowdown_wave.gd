class_name SlowdownWave extends Weapon_2

func _attack() -> void:
	for mob in _area_2d.get_overlapping_areas():
		mob.apply_slow(stats.effect_intensity, stats.effect_duration)
