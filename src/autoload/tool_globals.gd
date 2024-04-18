extends Node

var pen_size
var pen_opacity
var pen_color
var eraser_size
var eraser_opacity

func set_global_variable(var_name, value):
	print(value)
	match var_name:
		"pen_size":
			pen_size = value
		"pen_opacity":
			pen_opacity = value
		"pen_color":
			pen_color = value
		"eraser_size":
			eraser_size = value
		"eraser_opacity":
			eraser_opacity = value
		_:
			print("Unknown global variable:", var_name)
