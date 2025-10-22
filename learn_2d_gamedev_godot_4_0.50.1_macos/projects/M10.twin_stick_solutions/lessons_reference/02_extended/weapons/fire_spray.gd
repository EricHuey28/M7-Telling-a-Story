extends Weapon

@export var min_range := 300.0
@export var min_bullet_speed := 700.0
@export_range(10.0, 180.0, 0.001, "radians_as_degrees") var max_spread_angle := PI / 3.0

@onready var _cooldown_timer: Timer = %CooldownTimer


func _ready() -> void:
	_cooldown_timer.one_shot = true


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and _cooldown_timer.is_stopped():
		shoot()
		_cooldown_timer.start()


func shoot() -> void:
	for current_index: int in range(8):
		var bullet: Node = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)

		bullet.global_position = global_position
		var spread_angle = randf_range(-max_spread_angle / 2.0, max_spread_angle / 2.0)
		bullet.global_rotation = global_rotation + spread_angle
		bullet.max_range = randf_range(min_range, max_range)
		bullet.speed = randf_range(min_bullet_speed, max_bullet_speed)

	if shoot_sound != null:
		shoot_sound.play()
