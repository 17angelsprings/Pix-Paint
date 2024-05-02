extends Button

@export var next_scene: String 

func _on_pressed():
	print("Next scene")
	get_tree().change_scene_to_file(next_scene)
