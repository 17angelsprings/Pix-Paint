class_name LabeledSlider
extends Label

@export var slider: HSlider
@export var prefix: String
@export var global_var: String
var label_text

func _ready():
	label_text = prefix + str(slider.value)
	text = label_text
	ToolGlobals.set_global_variable(global_var,slider.value)
	
	slider.value_changed.connect(_update_label_text)
	
func _update_label_text(value):
	label_text = prefix + str(value)
	text = label_text
	ToolGlobals.set_global_variable(global_var, value)
	CanvasGlobals.reset_invisible_image()
