extends Button


var menu_scene = "res://src_web/ui_web/menu_web/menu.tscn"

func _on_pressed():
	## Navigate to the Main Menu scene
	get_tree().change_scene_to_file(menu_scene)
