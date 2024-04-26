extends Node

var file_path
var image = Image.create(1000, 1000, false, Image.FORMAT_RGBA8)

func get_global_variable(var_name):
	match var_name:
		"file_path":
			return file_path
		"image":
			return image
		_:
			print("Unknown global variable:", var_name)

func set_global_variable(var_name, value):
	print(value)
	match var_name:
		"file_path":
			file_path = value
		"image":
			image = value
		_:
			print("Unknown global variable:", var_name)
