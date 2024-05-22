extends TabContainer

# Changes the brush_eraser global variable to reflect whether the brush or eraser is selected
func _on_tab_clicked(tab):
	ToolGlobals.set_global_variable("brush_eraser", tab)
