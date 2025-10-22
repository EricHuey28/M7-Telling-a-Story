## Spawns mobs in a sequence, one by one, at fixed time intervals, until the
## spawner runs out of mobs to spawn.
##
## The spawner has a path for mobs to follow, which is calculated by the
## Roads tilemap layer at the start of the game.
class_name MobSpawner extends Node2D

## The mob to spawn
@export var mob_packed_scene := preload("mob.tscn")
## The number of mobs this spawner will spawn in total.
## Mobs will spawn one by one until this counter reaches 0.
@export var mobs_count := 10
@export var spawn_interval := 1.0

var _timer := Timer.new()

@onready var _remaining_mobs := mobs_count
@onready var _path: Path2D = get_node("Path2D")


func _ready() -> void:
	add_child(_timer)
	_timer.timeout.connect(spawn_mob)
	_timer.wait_time = spawn_interval
	_timer.start()


func spawn_mob() -> void:
	#ANCHOR:spawn_one_mob
	var mob_path_follow := MobPathFollow.new()
	_path.add_child(mob_path_follow)

	var mob: Mob = mob_packed_scene.instantiate()
	mob_path_follow.add_child(mob)
	mob_path_follow.mob = mob
	#END:spawn_one_mob

	#ANCHOR:mob_count
	_remaining_mobs -= 1
	if _remaining_mobs == 0:
		_timer.stop()
	#END:mob_count
