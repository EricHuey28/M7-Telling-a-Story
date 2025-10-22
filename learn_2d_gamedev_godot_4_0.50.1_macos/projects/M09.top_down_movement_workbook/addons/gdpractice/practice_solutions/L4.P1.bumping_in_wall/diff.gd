static func bumping_in_walls(scene_root: Node) -> void:
	var external_walls := scene_root.get_node("ExternalWallsStaticBody2D") as StaticBody2D
	for child in external_walls.get_children():
		external_walls.remove_child(child)
		child.queue_free()
