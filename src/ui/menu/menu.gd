extends Control


func _on_new_pressed():
	get_tree().change_scene_to_file("res://src/ui/menu/new_canvas.tscn")
	

func _on_open_pressed():
	$MarginContainer/VBoxContainer/Open/FileDialog.popup()


func _on_quit_pressed():
	get_tree().quit()

