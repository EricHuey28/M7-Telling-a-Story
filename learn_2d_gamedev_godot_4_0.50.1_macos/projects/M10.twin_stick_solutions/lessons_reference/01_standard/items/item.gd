# Compiles all the data for a given item in the game, which can be used by
# collectibles and the UI alike.
class_name Item extends Resource

@export var display_name := ""
@export var texture: Texture2D = null
@export var sound_on_pickup: AudioStream = null

# Override this function to define what happens when the player uses the item.
func use(player: Player) -> void:
	pass
