extends Node

var canvas_size = Vector2(100.0, 100.0)
var current_layer_idx

func get_global_variable(var_name):
	match var_name:
		"current_layer_idx":
			return current_layer_idx
		"canvas_size.x":
			return canvas_size.x
		"canvas_size.y":
			return canvas_size.y
		_:
			print("Unknown global variable:", var_name)

func set_global_variable(var_name, value):
	print(value)
	match var_name:
		"current_layer_idx":
			current_layer_idx = value
		"canvas_size.x":
			canvas_size.x = value
		"canvas_size.y":
			canvas_size.y = value
		_:
			print("Unknown global variable:", var_name)
