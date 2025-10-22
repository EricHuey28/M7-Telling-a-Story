extends Resource

## Path to the first version of the progress file.
const PATH_V1 := "user://progress.tres"
## Current path used to save the progress file, for the latest version.
const PATH := "user://progress_v2.tres"
## Backup path for the progress file. When saving progress, the current file is backed up to this path.
const BACKUP_PATH := "user://progress_v2_backup.tres"
## Path to write and read corrupted progress save files that failed to load
const CORRUPTED_PATH := "user://progress_v2_corrupted_%s.tres"

@export var state := {}

func _init() -> void:
	resource_path = PATH
