class_name MobPathFollow_2 extends PathFollow2D

var mob: Mob_2 = null: set = set_mob


func _physics_process(delta: float) -> void:
	progress += mob.speed * delta


func set_mob(new_mob: Mob_2) -> void:
	mob = new_mob
	mob.tree_exited.connect(queue_free)
