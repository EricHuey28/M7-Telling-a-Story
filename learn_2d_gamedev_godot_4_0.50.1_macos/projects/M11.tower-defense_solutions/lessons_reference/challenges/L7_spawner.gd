## Spawns multiple waves of mobs in a sequence, one by one, at fixed time
## intervals, until the spawner runs out of mobs to spawn.
##
## The spawner has a path for mobs to follow, which is calculated by the
## Roads tilemap layer at the start of the game.
extends Node2D

@export var waves := [
	{
		"mobs_count": 2,
		"spawn_interval": 1.0,
	},
	{
		"mobs_count": 5,
		"spawn_interval": 0.6,
	},
	{
		"mobs_count": 30,
		"spawn_interval": 1.0,
	},
]

## The mob to spawn
@export var mob_packed_scene := preload("../mobs/mob.tscn")

var _timer := Timer.new()
## This timer is used to delay the start of the next wave
var _wave_delay_timer := Timer.new()
var _current_wave_index := 0
var _remaining_mobs := 0

@onready var _path: Path2D = get_node("Path2D")


func _ready() -> void:
	add_child(_timer)
	add_child(_wave_delay_timer)

	_timer.timeout.connect(spawn_mob)

	_wave_delay_timer.one_shot = true
	_wave_delay_timer.wait_time = 2.0
	_wave_delay_timer.timeout.connect(start_next_wave)

	start_wave(_current_wave_index)


func start_next_wave() -> void:
	start_wave(_current_wave_index)


func start_wave(wave_index: int) -> void:
	if wave_index >= waves.size():
		return

	var wave = waves[wave_index]
	_remaining_mobs = wave.mobs_count
	_timer.wait_time = wave.spawn_interval
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
		_current_wave_index += 1
		_wave_delay_timer.start()
	#END:mob_count
