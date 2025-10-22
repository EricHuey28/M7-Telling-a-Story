## Keeps track of the student's progress. Most importantly which practices have been completed.
const Progress := preload("progress.gd")
const Paths := preload("../paths.gd")
const Metadata := preload(Paths.SOLUTIONS_PATH + "/metadata.gd")

const PracticeMetadata := Metadata.PracticeMetadata

var progress: Progress = null


func _init(metadata: Metadata) -> void:
	# We make a backup of student progress in the rare cases progress files fail
	# to load or gets corrupted. In this code, we first try loading the main
	# progress file and if it's empty, we fall back onto the backup.
	if ResourceLoader.exists(Progress.PATH):
		progress = _safe_load_resource(Progress.PATH)

	# If main file didn't load, try the backup and save it over the main file
	if progress == null and ResourceLoader.exists(Progress.BACKUP_PATH):
		push_warning("Main progress file could not be loaded. Trying to load backup...")
		progress = _safe_load_resource(Progress.BACKUP_PATH)
		if progress != null:
			push_warning("Successfully loaded progress from backup file.")
			save()

	# Try legacy format if both main and backup failed
	if progress == null and ResourceLoader.exists(Progress.PATH_V1):
		push_warning("Trying to load legacy progress file format...")
		progress = _update_save_file_format()
		if progress != null:
			save()

	# Create a new progress file if all loading attempts failed
	if progress == null:
		push_warning("Could not load any existing progress file. Creating a new one.")
		progress = Progress.new()
		for practice_metadata: PracticeMetadata in metadata.list:
			progress.state[practice_metadata.id] = {completion = 0, tries = 0}
		save()


## Checks if a file exists and is readable, with warning and error handling.
## This function is used to write warnings to the output bottom panel in case a
## student encounters issues, so that they can report them to us.
func _is_file_readable(path: String) -> bool:
	if not FileAccess.file_exists(path):
		push_warning("File does not exist: %s" % path)
		return false

	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("File exists but could not be opened: %s. Error: %s" %
				[path, error_string(FileAccess.get_open_error())])
		return false

	file.close()
	return true


## Attempts to safely load a resource, with error handling.
## Some students have had rare occurrences of user data files getting corrupted
## or lost by their system, so this function is designed to help be extra
## careful and log errors to the output bottom panel for bug reporting.
func _safe_load_resource(path: String) -> Resource:
	if not _is_file_readable(path):
		push_error("Progress file is not readable: %s" % path)
		return null

	var resource := ResourceLoader.load(path)
	if resource == null:
		push_error("Loaded null resource from %s" % path)
		_backup_corrupted_file(path)
		return null

	if not "state" in resource or resource.get("state") is not Dictionary:
		push_error("Loaded resource from %s doesn't have a valid state dictionary" % path)
		_backup_corrupted_file(path)
		return null

	return resource


## Backup a corrupted progress file to recover in case of issues or for students to upload when reporting bugs.
func _backup_corrupted_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		return

	var timestamp = Time.get_datetime_string_from_system().replace(":", "-").replace(" ", "_")
	var backup_path = Progress.CORRUPTED_PATH % timestamp

	var error = DirAccess.copy_absolute(path, backup_path)
	if error != OK:
		push_error("Failed to backup corrupted file from %s to %s: %s" % [path, backup_path, error_string(error)])
	else:
		push_warning("Backed up corrupted progress file to %s" % backup_path)


func save() -> void:
	# Validate the progress resource before saving
	if progress == null:
		push_error("Cannot save null progress resource")
		return

	if not progress.get("state") is Dictionary:
		push_error("Cannot save progress with invalid state property")
		return

	# First back up the current file if it exists
	if FileAccess.file_exists(Progress.PATH):
		if _is_file_readable(Progress.PATH):
			var error = DirAccess.copy_absolute(Progress.PATH, Progress.BACKUP_PATH)
			if error != OK:
				push_error("Failed to create backup before saving: %s" % error_string(error))
			else:
				if not _is_file_readable(Progress.BACKUP_PATH):
					push_error("Backup file was not created successfully")
		else:
			push_warning("Current progress file is not readable, skipping backup")

	# Now save the new file
	var error = ResourceSaver.save(progress, Progress.PATH)
	if error != OK:
		push_error("Failed to save progress file: %s" % error_string(error))
		return

	# Verify the saved file
	if not _is_file_readable(Progress.PATH):
		push_error("Progress file was not saved successfully")
		return

	# Try to load the file we just saved to ensure it's valid, if not, restore
	# from backup. This is an attempt to prevent corrupted files from being
	# saved and to catch file corruption issues right away.
	var test_load = _safe_load_resource(Progress.PATH)
	if test_load == null:
		push_error("Saved progress file cannot be loaded - it may be corrupted")
		if FileAccess.file_exists(Progress.BACKUP_PATH):
			push_warning("Attempting to restore from backup...")
			var restore_error = DirAccess.copy_absolute(Progress.BACKUP_PATH, Progress.PATH)
			if restore_error != OK:
				push_error("Failed to restore from backup: %s" % error_string(restore_error))
	else:
		print("Progress saved successfully")


func update(dict: Dictionary) -> void:
	for id in dict:
		for key in dict[id]:
			if (
				key == "completion"
				and progress.state.has(id)
				and progress.state[id].completion == 1
			):
				continue
			if not progress.state.has(id):
				progress.state[id] = {}
			progress.state[id][key] = dict[id][key]
	progress.emit_changed()


## Updates the save file format if it's outdated and returns the updated progress resource.
static func _update_save_file_format() -> Progress:
	# We renamed the addon folder at some point for Windows users, this requires migrating the original save data.
	# We need to first replace the path to the loader resource in the save file to load it, then save it back.
	if ResourceLoader.exists(Progress.PATH_V1):
		print("Migrating progress save file from version 1 to the new resource file format...")
		# Open the file as text and replace V1_RESOURCE_CLASS_PATH with Progress.resource_path
		const V1_RESOURCE_CLASS_PATH := "res://addons/gdquest_practice_framework/db/progress.gd"
		var file := FileAccess.open(Progress.PATH_V1, FileAccess.READ_WRITE)
		if file == null:
			push_error("Failed to open progress V1 file for migration: %s" % error_string(FileAccess.get_open_error()))
			return null

		var content := file.get_as_text().replace(V1_RESOURCE_CLASS_PATH, Progress.resource_path)
		file.store_string(content)
		file.close()

		var progress_v1 = null
		if ResourceLoader.exists(Progress.PATH_V1):
			progress_v1 = ResourceLoader.load(Progress.PATH_V1)
			progress_v1 = progress_v1.duplicate(true) if progress_v1 != null else null

		if progress_v1 == null:
			push_error("Failed to load the progress save file from version 1.")
		else:
			print("Success! The progress save file has been migrated to the new resource file format.")
		return progress_v1

	return null
