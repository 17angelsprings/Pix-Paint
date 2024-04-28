extends Node

# Open button is pressed so opening proces begins
func _on_pressed():
	print("open button is pressed")
	var file_path = FileGlobals.get_default_file_path()
	$FileDialog.set_filters(PackedStringArray(["*.png ; PNG Images"]))
	if file_path == "0":
		var fd_dir = $FileDialog.get_current_dir()
		var default_dir = fd_dir.erase(fd_dir.length() - 8, 8)
		FileGlobals.set_default_file_path(default_dir)
		print(default_dir)
		$FileDialog.set_current_path(default_dir)
		$FileDialog.popup()
	else:
		$FileDialog.set_current_path(file_path)
		$FileDialog.popup()


func _on_file_dialog_file_selected(path):
	
	# Load the file and image
	var image = Image.new()
	image.load(path)
	
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	
	FileGlobals.set_global_variable("image", image)
	FileGlobals.set_global_variable("file_path", path)
	FileGlobals.set_default_file_path(path)
	
	# Extract necessary variables (dimensions)
	
	
	# Hold texture in a global variable to transfer to workspace then go to it
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")
