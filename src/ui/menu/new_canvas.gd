extends Control

var project_name


# OK button is pressed -> proceed to Workspace
func _on_ok_pressed():
	
	# save project name
	project_name = $MarginContainer/HBoxContainer/LineEdit.get_text()
	if project_name == "":
		project_name = "project"
	ProjectGlobals.set_global_variable("project_name",project_name)
	
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

# Cancel button is pressed -> go back to Main Menu
func _on_cancel_pressed():
	get_tree().change_scene_to_file("res://src/ui/menu/menu.tscn")

