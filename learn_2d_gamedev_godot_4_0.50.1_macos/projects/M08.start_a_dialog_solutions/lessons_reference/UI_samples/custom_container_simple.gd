@tool
extends Container

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		for child in get_children():
			if child is Control:
				# We create a geometrical rectangle from the point (0,0)
				# which is top left, down to the size of this container.
				# this fills the entire container
				var child_rectangle := Rect2(Vector2.ZERO, size)
				fit_child_in_rect(child, child_rectangle)
