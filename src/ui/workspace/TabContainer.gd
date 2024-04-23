extends TabContainer

# Changes the pen_eraser global variable to reflect whether the pen or eraser is selected
func _on_tab_changed(tab):
	ToolGlobals.set_global_variable("pen_eraser", tab)
