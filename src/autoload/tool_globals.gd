extends Node

# 0 is pen; 1 is eraser
var pen_eraser: bool = 0
var pen_size
var pen_opacity
var pen_color
var eraser_size
var eraser_opacity

func get_global_variable(var_name):
	match var_name:
		"pen_eraser":
			return pen_eraser
		"pen_size":
			return pen_size
		"pen_opacity":
			return pen_opacity
		"pen_color":
			return pen_color
		"eraser_size":
			return eraser_size
		"eraser_opacity":
			return eraser_opacity
		_:
			print("Unknown global variable:", var_name)

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
