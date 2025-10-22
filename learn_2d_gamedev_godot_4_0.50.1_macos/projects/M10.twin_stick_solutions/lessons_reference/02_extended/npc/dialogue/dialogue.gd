@tool
class_name Dialogue extends Resource

@export var entries: Array[DialogueEntry] = []: set = set_entries

func set_entries(new_entries: Array[DialogueEntry]) -> void:
	for index in new_entries.size():
		if new_entries[index] == null:
			new_entries[index] = DialogueEntry.new()
	entries = new_entries
