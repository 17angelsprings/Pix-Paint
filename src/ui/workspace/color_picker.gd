extends ColorPicker


# Called when the node enters the scene tree for the first time.
func _ready():
	color = Color(0.0 , 0.0, 0.0);
	ToolGlobals.set_global_variable("pen_color", color)

func _on_color_changed(color):
	ToolGlobals.set_global_variable("pen_color", color)
