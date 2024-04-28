extends Control

# NO LONGER IN USE: BUTTONS HAVE THEIR OWN REUSABLE SCRIPTS

# New button is pressed -> create set parameters for brand new Canvas
func _on_new_pressed():
	get_tree().change_scene_to_file("res://src/ui/menu/new_canvas.tscn")
	
# Open button is pressed -> file dialogue appears so you can choose previously existing image
func _on_open_pressed():
	var file_path = FileGlobals.get_default_file_path()
	$MarginContainer/VBoxContainer/Open/FileDialog.set_filters(PackedStringArray(["*.png ; PNG Images"]))
	if file_path == "0":
		var fd_dir = $MarginContainer/VBoxContainer/Open/FileDialog.get_current_dir()
		var default_dir = fd_dir.erase(fd_dir.length() - 8, 8)
		FileGlobals.set_default_file_path(default_dir)
		$MarginContainer/VBoxContainer/Open/FileDialog.set_current_path(default_dir)
		$MarginContainer/VBoxContainer/Open/FileDialog.popup()
	else:
		$MarginContainer/VBoxContainer/Open/FileDialog.set_current_path(file_path)
		$MarginContainer/VBoxContainer/Open/FileDialog.popup()
	
# After user selects a file, the file will be loaded and then take them to the workspace
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
	

# Quit button is pressed-> exits out of program
func _on_quit_pressed():
	get_tree().quit()


