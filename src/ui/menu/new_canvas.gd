extends Control

# OK button is pressed -> proceed to Workspace
func _on_ok_pressed():
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

# Cancel button is pressed -> go back to Main Menu
func _on_cancel_pressed():
	get_tree().change_scene_to_file("res://src/ui/menu/menu.tscn")

