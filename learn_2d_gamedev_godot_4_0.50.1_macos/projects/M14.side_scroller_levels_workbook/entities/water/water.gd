@tool
class_name Water extends ColorRect

@export var water_color := Color("2d78ba"): set = set_water_color


func _init() -> void:
	if material == null:
		material = preload("water_mat.tres")


func _ready() -> void:
	# Make the material unique so that changing the ratio
	# of one water bed does not affect other water beds.
	material = material.duplicate()
	resized.connect(func(): _set_ratio())
	_set_ratio()
	set_water_color(water_color)


func set_water_color(value: Color) -> void:
	water_color = value
	if material != null:
		material.set_shader_parameter("water_color", water_color)


func _set_ratio() -> void:
	material.set_shader_parameter("height", size.y)
	material.set_shader_parameter("ratio", size.x / size.y)
