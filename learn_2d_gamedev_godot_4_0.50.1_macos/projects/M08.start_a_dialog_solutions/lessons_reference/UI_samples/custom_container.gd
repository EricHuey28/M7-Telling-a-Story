## A container that places its children in a circle.
## Offsets for radius and angle can be manually adjusted in the editor.[br]
## Can be used for radial menus and the like
@tool
@icon('./assets/radial_container.svg')
extends Container

## Adds a margin to the circle's radius.
@export_range(0, 100, 1, "or_greater", "or_less") var radius_offset := 0.0: 
	set = set_radius_offset

## Shifts the items clockwise or counter clockwise. Value is in radians (but displayed value in the 
## editor is in degrees).
@export_range(-180, 180, 0.001, "radians_as_degrees") var angle_offset := - PI / 2: 
	set = set_angle_offset


## This gets called by Godot whenever it sends notifications. Notifications are
## like low level signals, used internally by the engine. They are dispatched on 
## numerous occasion. Check the documentation for [code]_notification[/code] to 
## learn more.
func _notification(what: int) -> void:
	# This is a request to resort the children
	# it is dispatched anytime any event happens that would require to act on the container's
	# children, such as resizing the container, adding a child, and so on.
	if what == NOTIFICATION_SORT_CHILDREN:
		sort_children()


## Sets all children on a circle around the center point of the container.
func sort_children() -> void:
	# We divide a full circle by the amount of children.
	# This assumes all children and controls
	var space_between_items := TAU / get_child_count()
	# We find the center of the container
	var center_offset := size / 2
	# We make sure the circle fits in the smallest side of the container
	var radius := center_offset.x if center_offset.x < center_offset.y else center_offset.y
	# We add the offset
	radius += radius_offset
	# We loop over children by index (not by node). We need the index
	for index in get_child_count():
		# We retrieve the child. Using `as Control` will make child `null`
		# if the child isn't a Control, which acts as a guarantee.
		var child := get_child(index) as Control
		if child != null:
			# We calculate the angle by multiplying the spacing by the current index.
			# We then shift that angle by the angle offset.
			var angle := space_between_items * index + angle_offset
			# We create a vector of `radius` length and rotate it to the angle.
			# Then, we offset it by the size of half the control to center it.
			child.position = Vector2(radius, 0).rotated(angle) + center_offset


## Sets the [member radius_offset] value
func set_radius_offset(new_offset: float) -> void:
	radius_offset = new_offset
	# queue_sort() is called automatically by godot when the container is 
	# resized or a child is added, but for custom properties, we need to manually
	# call it ourselves
	queue_sort()


## Sets the [member angle_offset] value
func set_angle_offset(new_angle_offset_radians: float) -> void:
	angle_offset = new_angle_offset_radians
	# queue_sort() is called automatically by godot when the container is 
	# resized or a child is added, but for custom properties, we need to manually
	# call it ourselves
	queue_sort()
