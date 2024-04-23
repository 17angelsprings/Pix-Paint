extends TabContainer










func _on_tab_changed(tab):
	ToolGlobals.set_global_variable("pen_eraser", tab)
	print(ToolGlobals.get_global_variable("pen_eraser"))
