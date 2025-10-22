static func coin(scene_root: Node) -> void:
    var collision_shape = scene_root.get_node("CollisionShape2D")
    scene_root.remove_child(collision_shape)
    var sprite_2d = scene_root.get_node("Sprite2D")
    scene_root.remove_child(sprite_2d)
    scene_root.set_script(null)

static func ship_create_coins(scene_root: Node) -> void:
    pass

static func create_coins(scene_root: Node) -> void:
    var coins := scene_root.find_children("Coin*")
    for coin in coins:
        scene_root.remove_child(coin)
    