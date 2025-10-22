static func edit_project_configuration() -> void:
	ProjectSettings.set_setting('application/run/main_scene', "res://tower_defense.tscn")
	ProjectSettings.set_setting('autoload/PlayerUI', "*res://autoload/player_ui.tscn")
	ProjectSettings.set_setting('autoload/UpgradeDatabase', null)
	ProjectSettings.save()
