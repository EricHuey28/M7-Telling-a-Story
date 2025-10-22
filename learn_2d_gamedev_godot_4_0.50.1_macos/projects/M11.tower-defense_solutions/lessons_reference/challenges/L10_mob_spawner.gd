## This version of the mob spawner is tweaked to update a mob count in the auto-loaded win screen.
## Using an autoload for the win screen is a simple way to track spawned mobs.
extends Node2D

# As this is just a reference to help solve the challenge, I'm not registering
# the win screen as an autoload in the project. This line of code allows me to
# refer to the WinScreen class in this script without errors.
var WinScreen := preload("L10_win_screen.gd").new()

@export var mob_packed_scene := preload("res://lessons_reference/mobs/mob.tscn")

## The number of mobs this spawner will spawn in total.
## Mobs will spawn one by one until this counter reaches 0.
@export var mobs_count := 10
@export var spawn_interval := 1.0

var _timer := Timer.new()

@onready var _remaining_mobs := mobs_count
@onready var _path: Path2D = get_node("Path2D")


func _ready() -> void:
	WinScreen.mobs_left_to_spawn += mobs_count

	add_child(_timer)
	_timer.timeout.connect(spawn_mob)
	_timer.wait_time = spawn_interval
	_timer.start()


func spawn_mob() -> void:
	WinScreen.live_mob_count += 1
	WinScreen.mobs_left_to_spawn -= 1

	var mob_path_follow := MobPathFollow.new()
	_path.add_child(mob_path_follow)

	var mob: Mob = mob_packed_scene.instantiate()
	mob_path_follow.add_child(mob)
	mob_path_follow.mob = mob
	mob.tree_exited.connect(func ():
		WinScreen.live_mob_count -= 1
	)

	_remaining_mobs -= 1
	if _remaining_mobs == 0:
		_timer.stop()
