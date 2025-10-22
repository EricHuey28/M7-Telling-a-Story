static func coin(scene_root: Node) -> void:
	scene_root.remove_from_group("coin")

static func energy_pack(scene_root: Node) -> void:
	scene_root.remove_from_group("energy")

static func coins_and_energy_packs(scene_root: Node) -> void:
	for child: Node in scene_root.get_children():
		child.remove_from_group("coin")
		child.remove_from_group("energy")
	
static func ship_coins_and_energy_packs(scene_root: Node) -> void:
	pass
