extends Node

# File Path variable that stores the path of an opened project
# Set to default_path set in "res://src/autoload/path.txt"
var file_path = get_default_file_path()

# Image variable that stores the image from which the canvas will be created from
# Blank image by default but will be overwritted by a loaded image if applicable
var image = Image.create(1000, 1000, false, Image.FORMAT_RGBA8)

# Keeps track of whether the Save button in the workspace was pressed
# False by default, but turns true when presed
var save_button_pressed = false

# Keeps track of whether the Export button in the workspace was pressed
# False by default, but turns true when pressed
var export_button_pressed = false

func get_global_variable(var_name):
	match var_name:
		"file_path":
			return file_path
		"image":
			return image
		"save_button_pressed":
			return save_button_pressed
		_:
			print("Unknown global variable:", var_name)

func set_global_variable(var_name, value):
	print(value)
	match var_name:
		"file_path":
			file_path = value
		"image":
			image = value
		"save_button_pressed":
			save_button_pressed = value
		_:
			print("Unknown global variable:", var_name)
			
func get_default_file_path():
	var path_file = "res://src/autoload/path.txt"
	var line_count = 0
	var content
	var file = FileAccess.open(path_file, FileAccess.READ)
	while not file.eof_reached() and line_count < 1:
		content = file.get_line()
		line_count += 1
	return content
	
func set_default_file_path(path):
	var path_file = "res://src/autoload/path.txt"
	var file = FileAccess.open(path_file, FileAccess.WRITE)
	file.store_string(path)
