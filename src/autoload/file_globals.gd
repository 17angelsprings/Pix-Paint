## FILE GLOBALS .GD
## ********************************************************************************
## Script for global variables relating to the file I/O and images
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## File Path variable that stores the path of an opened project
## Set to default_path set in "res://src/autoload/path.txt"
var file_path = get_default_file_path()

## Image variable that stores the image from which the canvas will be created from
## Blank image by default but will be overwritted by a loaded image if applicable
var image

## Previous image
## Stores most recent image on the workspace during a work session so that user may
## still have the image they were working on even if they didn't save first before
## taking another action such as opening a new canvas and then cancelling it
var prev_image

## Project file
var project_file: FileAccess

## Project name
var project_name

## Keeps track of whether the Save button in the workspace was pressed
## False by default, but turns true when presed
var save_button_pressed = false

## Keeps track of whether the Export button in the workspace was pressed
## False by default, but turns true when presed
var export_button_pressed = false

## Indicates whether the New Canvas menu was accessed from the workspace or not
var accessed_from_workspace = false

## FUNCTIONS
## ********************************************************************************

## Looks up global variable value
## @params: var_name - name of global variable being looked up
## @return: any type of assignable value or none if global variable does not exist in this script
func get_global_variable(var_name):
	match var_name:
		"file_path":
			return file_path
		"image":
			return image
		"project_file":
			return project_file
		"project_name":
			return project_name
		"save_button_pressed":
			return save_button_pressed
		"export_button_pressed":
			return export_button_pressed
		"accessed_from_workspace":
			return accessed_from_workspace
		"prev_image":
			return prev_image
		_:
			print("Unknown global variable:", var_name)

## Sets global variable value
## @params: 
## var_name - name of global variable to change
## value - value to change specified global variable to
## @return: none
func set_global_variable(var_name, value):
	print(value)
	match var_name:
		"file_path":
			file_path = value
		"image":
			image = value
		"project_file":
			project_file = value
		"project_name":
			project_name = value
		"save_button_pressed":
			save_button_pressed = value
		"export_button_pressed":
			export_button_pressed = value
		"accessed_from_workspace":
			accessed_from_workspace = value
		"prev_image":
			prev_image = value
		_:
			print("Unknown global variable:", var_name)

## Retrieves path stored in path.txt
## It is the default / most recently used file path
## @params: none
## @return: string - contains contents of path.txt
func get_default_file_path():
	var path_file = "res://src/autoload/path.txt"
	var line_count = 0
	var content
	var file = FileAccess.open(path_file, FileAccess.READ)
	while not file.eof_reached() and line_count < 1:
		content = file.get_line()
		line_count += 1
	print(content)
	return content

## Sets contents in path.txt to be the new
## default / most recently used file path
## @params: content - string content to be set in path.txt
## @return: none
func set_default_file_path(content):
	var path_file = "res://src/autoload/path.txt"
	var file = FileAccess.open(path_file, FileAccess.WRITE)
	file.store_string(content)

## Creates new project file
## @params: var_name - name assigned to project
## @return: none
func new_project_file(var_name):
	project_file = FileAccess.open(var_name, FileAccess.WRITE)

## Opens existing project file
## @params: path - file path where project is store
## @return: none
func open_project_file(path):
	project_file = FileAccess.open(path, FileAccess.READ_WRITE)
	
