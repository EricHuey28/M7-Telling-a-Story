## Spawns mobs in a sequence, one by one, at fixed time intervals, until the
## spawner runs out of mobs to spawn.
##
## The spawner has a path for mobs to follow, which is calculated by the
## Roads tilemap layer at the start of the game.
#ANCHOR:l2_head
class_name MobSpawner_2 extends Node2D

@export var mob_packed_scene := preload("mob.tscn")
@export var mobs_count := 10
@export var spawn_interval := 1.0

var _timer := Timer.new()

@onready var _remaining_mobs := mobs_count

#END:l2_head
var _path := Path2D.new()


func _ready() -> void:
	#ANCHOR:l2_timer
	add_child(_timer)
	_timer.timeout.connect(spawn_mob)
	_timer.wait_time = spawn_interval
	_timer.start()
	#END:l2_timer

	#ANCHOR:l2_path
	_path.top_level = true
	add_child(_path)
	_path.curve = Curve2D.new()
	#END:l2_path


func spawn_mob() -> void:
	var mob_path_follow := MobPathFollow_2.new()
	_path.add_child(mob_path_follow)

	var mob: Mob_2 = mob_packed_scene.instantiate()
	mob_path_follow.add_child(mob)
	mob_path_follow.mob = mob

	_remaining_mobs -= 1
	if _remaining_mobs == 0:
		_timer.stop()


func initialize_path(points: PackedVector2Array) -> void:
	_path.curve.clear_points()
	for point in points:
		_path.curve.add_point(point)
