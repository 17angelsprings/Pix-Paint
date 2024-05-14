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
	get_tree().change_scene_to_file("res://src/ui/menu/menu.tscn")

