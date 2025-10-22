extends Weapon

@onready var _cooldown_timer: Timer = %CooldownTimer


func _ready() -> void:
	_cooldown_timer.one_shot = true


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		shoot()
		_cooldown_timer.start()
