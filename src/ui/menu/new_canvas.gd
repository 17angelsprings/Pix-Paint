extends Control

func _on_ok_pressed():
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")


func _on_cancel_pressed():
	get_tree().change_scene_to_file("res://src/ui/menu/menu.tscn")
