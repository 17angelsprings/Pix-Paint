class_name CanvasSpinbox
extends SpinBox

@export var global_var: String

func _ready():
	value = CanvasGlobals.get_global_variable(global_var)
	CanvasGlobals.set_global_variable(global_var, value)

func _on_value_changed(value_picked):
	CanvasGlobals.set_global_variable(global_var, value_picked)
