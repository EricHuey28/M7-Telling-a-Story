extends Control

signal health_depleted

## The amount of coins the player currently has.
var health := 5: set = set_health
var coins := 0: set = set_coins

@onready var _heart_h_box_container: HBoxContainer = %HeartHBoxContainer
@onready var _coin_label: Label = %CoinLabel
@onready var _coin_icon: TextureRect = %CoinIcon


func _ready() -> void:
	#ANCHOR: l3_ready_health
	set_health(health)
	#END: l3_ready_health
	#ANCHOR: l3_ready_coins
	set_coins(coins)
	#END: l3_ready_coins


func get_coin_ui_position() -> Vector2:
	return _coin_icon.global_position + _coin_icon.size / 2


func set_health(new_health: int) -> void:
	health = clampi(new_health, 0, 5)
	if health == 0:
		health_depleted.emit()

	for child in _heart_h_box_container.get_children():
		child.visible = health > child.get_index()


func set_coins(new_coins: int) -> void:
	coins = maxi(0, new_coins)
	if _coin_label != null:
		_coin_label.text = str(coins)
