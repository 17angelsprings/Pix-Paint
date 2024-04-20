extends Control

# Current values for Canvas width and height (100 px X 100 px by default)
@onready var cur_width = get_node("CanvasSizeContainer/WidthSpinBox").get_value()

@onready var cur_height = get_node("CanvasSizeContainer/HeightSpinBox").get_value()

# 
@export var global_var: String

# Updates Cavnas width value
func _on_width_spin_box_value_changed(value):
	cur_width = value
	CanvasGlobals.set_global_variable(global_var, value)

# Updates Cavnas height value	
func _on_height_spin_box_value_changed(value):
	cur_height = value
	CanvasGlobals.set_global_variable(global_var, value)

# OK button is pressed -> proceed to workspace
func _on_ok_pressed():
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

# Cancel button is pressed -> go back to Main Menu
func _on_cancel_pressed():
	get_tree().change_scene_to_file("res://src/ui/menu/menu.tscn")



