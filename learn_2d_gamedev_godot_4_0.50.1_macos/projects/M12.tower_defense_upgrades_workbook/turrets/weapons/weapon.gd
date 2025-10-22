## Base class for weapons. It provides functions and nodes that weapons can use.
## Different weapons will act differently, so you need to extend this class to
## create a functional weapon. For example, not all weapons will shoot bullets,
## target and rotate toward mobs in the same way, or deal damage. A weapon may
## slow down mobs, apply status effects, or boost surrounding turrets.
##
## That's why this class doesn't provide default behavior or variables to track
## a current target.
#ANCHOR:class_name
@icon("res://icons/icon_weapon.svg")
class_name Weapon extends Sprite2D
#END:class_name

@export var mob_detection_range := 400.0
@export var attack_rate := 1.0
@export var max_rotation_speed := 2.0 * PI

var _area_2d := _create_area_2d()
var _collision_shape_2d := _create_collision_shape_2d()
var _timer := _create_timer()


func _ready() -> void:
	#ANCHOR:add_area
	add_child(_area_2d)
	#END:add_area
	#ANCHOR:add_collision_shape
	_area_2d.add_child(_collision_shape_2d)
	#END:add_collision_shape

	#ANCHOR:add_timer
	add_child(_timer)
	_timer.start()
	#END:add_timer
	#ANCHOR:connect_timer
	_timer.timeout.connect(_attack)
	#END:connect_timer

	#ANCHOR:z_index
	z_index = 10
	#END:z_index


func _create_area_2d() -> Area2D:
	var area := Area2D.new()
	area.monitoring = true
	area.monitorable = false
	return area


func _create_collision_shape_2d() -> CollisionShape2D:
	var collision_shape := CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = mob_detection_range
	return collision_shape


func _create_timer() -> Timer:
	var timer := Timer.new()
	timer.wait_time = 1.0 / attack_rate
	return timer


## Virtual method. Called when it's time to attack.
func _attack() -> void:
	return
