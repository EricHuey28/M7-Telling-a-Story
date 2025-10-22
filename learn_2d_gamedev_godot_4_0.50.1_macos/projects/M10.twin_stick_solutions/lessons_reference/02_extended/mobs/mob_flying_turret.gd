extends Mob

@onready var _weapon: WeaponMobFireShot = %FireShot
@onready var _cooldown_timer: Timer = %CooldownTimer


func _ready() -> void:
	super()
	_cooldown_timer.wait_time = 1.0 / _weapon.fire_rate
	_cooldown_timer.timeout.connect(func () -> void:
		if _player != null:
			_weapon.shoot()
	)
	_cooldown_timer.start()


func _physics_process(delta: float) -> void:
	var desired_velocity := Vector2.ZERO
	if _player != null:
		var direction := global_position.direction_to(_player.global_position)
		var distance := global_position.distance_to(_player.global_position)
		var speed := max_speed if distance > 300.0 else max_speed * distance / 300.0
		desired_velocity = direction * speed
		_weapon.look_at(_player.global_position)

	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()
