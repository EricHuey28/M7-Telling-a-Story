@tool
class_name Turret extends Sprite2D

@export var weapon_scene: PackedScene = preload("weapons/simple_cannon.tscn"): set = set_weapon_scene

var weapon: Weapon = null


func _ready() -> void:
	set_weapon_scene(weapon_scene)
	texture = preload("res://turrets/turret_base.png")


func set_weapon_scene(new_scene: PackedScene) -> void:
	weapon_scene = new_scene

	#ANCHOR: remove_weapon
	if weapon != null:
		weapon.queue_free()
		#END: remove_weapon

	#ANCHOR: add_weapon
	if weapon_scene != null:
		var weapon_instance := weapon_scene.instantiate()
		assert(
			weapon_instance is Weapon,
			"The weapon scene must inherit from Weapon."
		)
		add_child(weapon_instance)
		weapon = weapon_instance
		#END: add_weapon
