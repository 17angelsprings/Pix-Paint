extends ColorPicker


# Called when the node enters the scene tree for the first time.
func _ready():
	color = Color(0.0 , 0.0, 0.0);
	ToolGlobals.set_global_variable("pen_color", color)

func _on_color_changed(color_picked):
	ToolGlobals.set_global_variable("pen_color", color_picked)
	CanvasGlobals.reset_invisible_image()
