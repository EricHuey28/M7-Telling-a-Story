@tool
class_name FallingPlatform extends Platform

var _player_detector: Area2D

@onready var _visual_root: Node2D = %VisualRoot
@onready var _reappear_timer: Timer = %ReappearTimer
@onready var _chunk_particles: GPUParticles2D = %ChunkParticles


func _ready() -> void:
	super()
	if Engine.is_editor_hint():
		return

	# Create player detector area
	_player_detector = Area2D.new()
	_player_detector.collision_layer = 0
	_player_detector.collision_mask = 1  # Player layer
	add_child(_player_detector)

	# Create shape for the detector
	var detector_shape := CollisionShape2D.new()
	detector_shape.shape = RectangleShape2D.new()
	detector_shape.shape.size = Vector2(width, 2)
	detector_shape.position = Vector2(0, 0)
	_player_detector.add_child(detector_shape)

	# Connect signals
	_player_detector.body_entered.connect(_on_player_detector_body_entered)
	_reappear_timer.timeout.connect(_reappear_timer_timeout)
	_chunk_particles.emitting = false


func set_width(value: float) -> void:
	super(value)
	if not is_inside_tree():
		return

	# Update detector shape if it exists
	if _player_detector and _player_detector.get_child_count() > 0:
		var detector_shape := _player_detector.get_child(0) as CollisionShape2D
		if detector_shape and detector_shape.shape is RectangleShape2D:
			detector_shape.shape.size.x = width

	_chunk_particles.emitting = false


func _on_player_detector_body_entered(body: Node2D) -> void:
	if not body is Player or not body.is_on_floor():
		return

	# Only trigger if player is coming from above, with a 2-pixel error margin
	if body.global_position.y > global_position.y + 2.0:
		return

	activate_falling_sequence()


func activate_falling_sequence() -> void:
	_chunk_particles.emitting = true
	var min_width := _sprite.patch_margin_left + _sprite.patch_margin_right
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_method(func(progress: float):
		var w := maxf(min_width, width * progress)
		_sprite.size.x = w
		_sprite.position.x = -w/2.0
		, 1.0, 0.0, 0.6)
	tween.parallel().tween_property(_visual_root, "scale", Vector2.ZERO, 0.4).set_delay(0.4)
	tween.tween_callback(func():
		_visual_root.hide()
		_collision_shape_2d.set_deferred("disabled", true)
		_chunk_particles.emitting = false
		)
	_reappear_timer.start(3.0)


func _reappear_timer_timeout() -> void:
	set_width(width)
	_visual_root.show()
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(_visual_root, "scale", Vector2.ONE, 0.1).from(Vector2.ONE * 0.2).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_callback(_collision_shape_2d.set_deferred.bind("disabled", false))
