class_name WeaponMobFireShot extends Weapon

@export var fire_rate := 0.6


func _physics_process(_delta: float) -> void:
	return


func shoot() -> void:
	var bullet: Bullet_2 = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)

	bullet.targets_player = true

	bullet.global_transform = global_transform
	bullet.max_range = 600.0
	bullet.speed = 400.0
	bullet.rotation += randf_range(-PI / 30.0, PI / 30.0)
