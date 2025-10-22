#ANCHOR: l4_head
@tool
class_name Turret_2 extends Sprite2D

@export var weapon_scene: PackedScene = preload("weapons/simple_cannon.tscn"): set = set_weapon_scene

var weapon: Weapon_2 = null
#END: l4_head
var level := 1


func _ready() -> void:
	set_weapon_scene(weapon_scene)
	texture = preload("res://turrets/turret_base.png")


func set_weapon_scene(new_scene: PackedScene) -> void:
	#ANCHOR:set_weapon_scene_head
	weapon_scene = new_scene

	if weapon != null:
		weapon.queue_free()

	if weapon_scene != null:
		var weapon_instance := weapon_scene.instantiate()
		assert(
			weapon_instance is Weapon_2,
			"The weapon scene must inherit from Weapon."
		)
		#END:set_weapon_scene_head
		#ANCHOR:set_weapon_scene_stats
		if weapon != null:
			weapon_instance.stats = weapon.stats
			#END:set_weapon_scene_stats

		#ANCHOR:set_weapon_scene_tail
		add_child(weapon_instance)
		weapon = weapon_instance
		#END:set_weapon_scene_tail
