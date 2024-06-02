extends Button

var creds_perms_page = "res://src_web/ui_web/menu_web/creds_perms.tscn"


func _on_pressed():
	get_tree().change_scene_to_file(creds_perms_page)
