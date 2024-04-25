extends Control

var pix_dict
var json_string




func _on_save_button_pressed():
	ProjectGlobals.new_project_file(ProjectGlobals.get_global_variable("project_name"))
	pix_dict = {
		"layer_0" : get_node("WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/ViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/SubViewportContainer/SubViewport/Canvas/mouse_grid").image.get_data()
	}
	json_string = JSON.stringify(pix_dict)
	ProjectGlobals.project_file.store_line(json_string)
