extends Node

signal canvas_size_changed

var canvas_size = Vector2(100.0, 100.0):
	set = set_canvas_size # when canvas changes, set_canvas_size is called
var current_layer_idx

func set_canvas_size(new_val):
	canvas_size_changed.emit() # emits a signal so other nodes can react to the change

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
