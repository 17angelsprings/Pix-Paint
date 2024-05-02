extends Control

func _ready():
	print("ready")
	var file_path = FileGlobals.get_default_file_path()
	if file_path == "0":
		var fd_dir = $MarginContainer/VBoxContainer/Open/FileDialog.get_current_dir()
		print("fd_dir:", fd_dir)
		var default_dir = fd_dir.erase(fd_dir.length() - 8, 8)
		FileGlobals.set_default_file_path(default_dir)
		print(default_dir)
		$MarginContainer/VBoxContainer/Open/FileDialog.set_current_path(default_dir)

func _on_new_pressed():
	pass # Replace with function body.
	# get_tree().change_scene_to_file()
	

func _on_open_pressed():
	$MarginContainer/VBoxContainer/Open/FileDialog.popup()


func _on_quit_pressed():
	get_tree().quit()

