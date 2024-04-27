extends Node

# Press this button to go back to the New Canvas menu and create a new canvas
func _on_pressed():
	get_tree().change_scene_to_file("res://src/ui/menu/new_canvas.tscn")
