extends Node

# Press this button to go back to the New Canvas menu and create a new canvas
func _on_pressed():
	FileGlobals.set_global_variable("image", Image.create(1000, 1000, false, Image.FORMAT_RGBA8))
	get_tree().change_scene_to_file("res://src/ui/menu/new_canvas.tscn")
