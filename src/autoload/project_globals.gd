extends Node

var project_file: FileAccess
var project_name


func get_global_variable(var_name):
	match var_name:
		"project_name": 
			return project_name
		_:
			print("Unknown global variable:", var_name)

func set_global_variable(var_name, value):
	match var_name:
		"project_name":
			project_name = value
		_:
			print("Unknown global variable:", var_name)

func new_project_file(var_name):
	project_file = FileAccess.open(var_name + ".pix", FileAccess.WRITE)
