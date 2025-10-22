static func ball(scene_root: Node) -> void:
	var collision_shape = scene_root.get_node("CollisionShape2D")
	scene_root.remove_child(collision_shape)

static func needle(scene_root: Node) -> void:
	pass

static func pop_the_ball(scene_root: Node) -> void:
	pass
