## The mob itself is a PathFollow2D node because all it does is follow a path.
class_name Mob_2 extends Area2D

@export var speed := 100.0
@export var health := 50.0: set = set_health
@export var damage := 10.0
@export var coins := 10

@export var texture_variations: Array[Texture] = []

@onready var _bar_pivot: Marker2D = %BarPivot

@onready var _health_bar: ProgressBar = %HealthBar
@onready var _sprite_2d: Sprite2D = %Sprite2D


func _ready() -> void:
	_health_bar.max_value = health
	set_health(health)

	area_entered.connect(func (_other_area: Area2D) -> void:
		_die()
	)

	if not texture_variations.is_empty():
		_sprite_2d.texture = texture_variations.pick_random()


func _physics_process(_delta: float) -> void:
	_bar_pivot.global_rotation = 0.0


func set_health(new_health: float) -> void:
	#ANCHOR: l3_set_health
	health = maxf(0.0, new_health)

	if _health_bar != null:
		_health_bar.value = health

	if health <= 0.0:
		#END: l3_set_health
		#ANCHOR: l3_set_health_die
		_die(true)
		#END: l3_set_health_die


func take_damage(amount: float) -> void:
	health -= amount

	var damage_indicator: Node2D = preload("damage_indicator.tscn").instantiate()
	get_tree().current_scene.add_child(damage_indicator)
	damage_indicator.global_position = global_position
	damage_indicator.display_amount(amount)


func _die(was_killed := false) -> void:
	#ANCHOR: l3_die_was_killed
	if was_killed:
		for current_index: int in coins:
			var coin: Node2D = preload("coin.tscn").instantiate()
			get_tree().current_scene.add_child.call_deferred(coin)
			coin.global_position = global_position
			#END: l3_die_was_killed

	#ANCHOR: l3_die_free
	queue_free()
	#END: l3_die_free
