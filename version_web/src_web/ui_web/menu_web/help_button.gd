extends Button

var help_page = "res://src_web/ui_web/menu_web/help.tscn"

func _on_pressed():
	get_tree().change_scene_to_file(help_page)
