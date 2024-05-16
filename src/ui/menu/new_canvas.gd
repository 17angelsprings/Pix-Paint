extends Control

# OK button is pressed -> proceed to Workspace
func _on_ok_pressed():
	var project_name = $HBoxContainer/VBoxContainer/FileNameMarginContainer/HBoxContainer/LineEdit.get_text()
	if project_name == "":
		project_name = "project"
	FileGlobals.set_global_variable("project_name",project_name)	
	var image = Image.create(CanvasGlobals.get_global_variable("canvas_size.x"), CanvasGlobals.get_global_variable("canvas_size.y"), false, Image.FORMAT_RGBA8)
	FileGlobals.set_global_variable("image", image)
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

# Cancel button is pressed -> go back to Main Menu
func _on_cancel_pressed():
	if FileGlobals.get_global_variable("accessed_from_workspace") == false:
		get_tree().change_scene_to_file("res://src/ui/menu/menu.tscn")
	else:
		var prev_x = CanvasGlobals.get_global_variable("prev_canvas_size.x")
		var prev_y = CanvasGlobals.get_global_variable("prev_canvas_size.y")
		CanvasGlobals.set_global_variable("canvas_size.x", prev_x)
		CanvasGlobals.set_global_variable("canvas_size.y", prev_y)
		FileGlobals.set_global_variable("image", FileGlobals.get_global_variable("prev_image"))
		get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

