extends Node

@export var file_dialog: FileDialog

var image: Image

# Open button is pressed so opening proces begins
func _on_pressed():
	FileGlobals.show_open_image_file_dialog_desktop(file_dialog)

func _on_file_dialog_file_selected(path):
	
	if path.ends_with(".pix"):
		FileGlobals.open_format = 1
		get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

	elif path.ends_with(".png"):
		FileGlobals.open_format = 2
		get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

	FileGlobals.set_most_recent_file_path(path)
