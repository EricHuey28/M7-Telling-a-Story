extends Area2D

@onready var canvas_group: CanvasGroup = $CanvasGroup
@onready var canvas_group_has_material: bool = canvas_group.material != null


func _ready() -> void:
	set_outline_thickness(5.0)


func set_outline_thickness(new_thickness: float) -> void:
	if canvas_group_has_material:
		canvas_group.material.set_shader_parameter("line_thickness", new_thickness)


func _on_mouse_entered() -> void:
	pass


func _on_mouse_exited() -> void:
	pass
