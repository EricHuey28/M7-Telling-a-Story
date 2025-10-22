@tool
extends Node

## The color of the sky background layer.
@export var sky_color := Color("152c53"): set = set_sky_color
## The tint color applied to the mountains layer.
@export var mountains_color := Color("2f3f88"): set = set_mountains_color
## The tint color applied to the mushrooms layer.
@export var mushrooms_color := Color("3f559e"): set = set_mushrooms_color

@export_group("Parallax Layers")
## Offsets the moon parallax layer. Use this to adjust the moon's position in the background.
@export var moon_scroll_offset := Vector2(634, 294): set = set_moon_scroll_offset
## The scroll offset for the mountains parallax layer. Use this to adjust the mountains' position in the background.
@export var mountains_scroll_offset := Vector2(0, 352): set = set_mountains_scroll_offset
## The scroll offset for the mushrooms parallax layer. Use this to adjust the mushrooms' position in the background.
@export var mushrooms_scroll_offset := Vector2(0, 338): set = set_mushrooms_scroll_offset

@onready var _sky: ColorRect = %Sky
@onready var _mountains: TileMapLayer = %Mountains
@onready var _mushrooms: TileMapLayer = %Mushrooms

@onready var _parallax_2d_moon: Parallax2D = %Parallax2DMoon
@onready var _parallax_2d_mountains: Parallax2D = %Parallax2DMountains
@onready var _parallax_2d_mushrooms: Parallax2D = %Parallax2DMushrooms


func _ready() -> void:
	set_sky_color(sky_color)
	set_mountains_color(mountains_color)
	set_mushrooms_color(mushrooms_color)

	set_moon_scroll_offset(moon_scroll_offset)
	set_mountains_scroll_offset(mountains_scroll_offset)
	set_mushrooms_scroll_offset(mushrooms_scroll_offset)


func set_sky_color(value: Color) -> void:
	sky_color = value
	if _sky != null:
		_sky.color = sky_color


func set_mountains_color(value: Color) -> void:
	mountains_color = value
	if _mountains != null:
		_mountains.modulate = mountains_color


func set_mushrooms_color(value: Color) -> void:
	mushrooms_color = value
	if _mushrooms != null:
		_mushrooms.modulate = mushrooms_color

func set_moon_scroll_offset(value: Vector2) -> void:
	moon_scroll_offset = value
	if _parallax_2d_moon != null:
		_parallax_2d_moon.scroll_offset = moon_scroll_offset


func set_mountains_scroll_offset(value: Vector2) -> void:
	mountains_scroll_offset = value
	if _parallax_2d_mountains != null:
		_parallax_2d_mountains.scroll_offset = mountains_scroll_offset


func set_mushrooms_scroll_offset(value: Vector2) -> void:
	mushrooms_scroll_offset = value
	if _parallax_2d_mushrooms != null:
		_parallax_2d_mushrooms.scroll_offset = mushrooms_scroll_offset
