@tool
class_name Platform extends AnimatableBody2D

enum PlatformColor {
	GROUND,
	YELLOW
}

const PLATFORM_TEXTURES = {
	PlatformColor.GROUND: preload("res://platform/ground_platform.png"),
	PlatformColor.YELLOW: preload("res://platform/yellow_platform.png")
}

## The width of the platform in pixels. Snaps to 16 pixel increments.
@export_range(32.0, 512.0, 16.0) var width := 128.0: set = set_width
## The height of the platform in pixels. Snaps to 16 pixel increments.
@export_range(8.0, 512.0, 8.0) var height := 16.0: set = set_height
## If true, the platform will only collide with the player from the top and let
## the player jump up through it.
@export var one_way_collision := false: set = set_one_way_collision
## This property lets you pick the color palette used by the platform.
@export var color: PlatformColor = PlatformColor.GROUND: set = set_color

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var shape: RectangleShape2D = collision_shape_2d.shape
@onready var sprite: NinePatchRect = %Sprite


func _ready() -> void:
	set_width(width)
	set_height(height)
	set_one_way_collision(one_way_collision)
	set_color(color)


func set_width(value: float) -> void:
	width = value
	if shape == null:
		return
	shape.size.x = width
	sprite.position.x = -width / 2.0
	sprite.size.x = width


func set_height(value: float) -> void:
	height = value
	if shape == null:
		return
	shape.size.y = height
	sprite.position.y = -height / 2.0
	sprite.size.y = height


func set_one_way_collision(value: bool) -> void:
	one_way_collision = value
	if collision_shape_2d == null:
		return
	collision_shape_2d.one_way_collision = one_way_collision


func set_color(value: PlatformColor) -> void:
	color = value
	if sprite == null:
		return
	sprite.texture = PLATFORM_TEXTURES[color]
