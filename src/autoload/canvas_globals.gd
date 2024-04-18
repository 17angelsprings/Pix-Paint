extends Node

var canvas_size = Vector2(100.0, 100.0)

func set_global_variable(var_name, value):
	print(value)
	match var_name:
		"canvas_size.x":
			canvas_size.x = value
		"canvas_size.y":
			canvas_size.y = value
		_:
			print("Unknown global variable:", var_name)
