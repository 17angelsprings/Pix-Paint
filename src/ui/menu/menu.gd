extends Control

# New button is pressed -> create set parameters for brand new Canvas
func _on_new_pressed():
	get_tree().change_scene_to_file("res://src/ui/menu/new_canvas.tscn")
	
# Open button is pressed -> file dialogue appears so you can choose previously existing image
func _on_open_pressed():
	$MarginContainer/VBoxContainer/Open/FileDialog.popup()

# Quit button is pressed-> exits out of program
func _on_quit_pressed():
	get_tree().quit()

