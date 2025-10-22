# This script is just a reference to help in solving the win screen challenge.
# it is meant to be registered as an autoload in the project settings and named
# WinScreen.
extends ColorRect

var live_mob_count := 0: set = set_live_mob_count
var mobs_left_to_spawn := 0: set = set_mobs_left_to_spawn

@onready var _play_again_button: Button = %PlayAgainButton
@onready var _quit_button: Button = %QuitButton


func _ready() -> void:
	visible = false

	# When pressing the retry button, we need to reset the health
	# because the PlayerUI is an autoload; it won't reset automatically.
	_play_again_button.pressed.connect(func() -> void:
		PlayerUI.health = 5
		get_tree().reload_current_scene()
	)
	_quit_button.pressed.connect(get_tree().quit)


func set_live_mob_count(new_count: int) -> void:
	live_mob_count = new_count
	if _player_has_won():
		visible = true


func set_mobs_left_to_spawn(new_count: int) -> void:
	mobs_left_to_spawn = new_count
	if _player_has_won():
		visible = true


## Returns true if the player meets the game's win conditions.
func _player_has_won() -> bool:
	return (
		live_mob_count == 0 and
		mobs_left_to_spawn == 0 and
		PlayerUI.health > 0
	)
