static func edit_project_configuration() -> void:
	ProjectSettings.set_setting('application/run/main_scene', "")
	ProjectSettings.save()
