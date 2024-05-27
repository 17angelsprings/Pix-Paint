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

## Settings config file
var settings_cfg = "user://settings.cfg"

## Most recently accessed file path
var most_recent_file_path

## Project file
var project_file: FileAccess

## For parsing/saving a project file
var json_string
var json
var node_data
var array
var pix_dict

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

func _ready():
	## Creates new Config file object
	var config = ConfigFile.new()
	
	get_most_recent_file_path()
	
	if most_recent_file_path == null:
		var first_path = OS.get_executable_path().get_base_dir() + "/"
		set_most_recent_file_path(first_path)
	

## Global Variable Functions
## **********************************************************

## Looks up global variable value
## @params: var_name - name of global variable being looked up
## @return: any type of assignable value or none if global variable does not exist in this script
func get_global_variable(var_name):
	match var_name:
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
		_:
			print("Unknown global variable:", var_name)

## Sets global variable value
## @params: 
## var_name - name of global variable to change
## value - value to change specified global variable to
## @return: none
func set_global_variable(var_name, value):
	match var_name:
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

		_:
			print("Unknown global variable:", var_name)

## File Path Functions
## **********************************************************

## Retrieves path stored in settings.cfg
## It is the most recently used file path
## @params: none
## @return: none
func get_most_recent_file_path():
	
	## Creates new Config file object
	var config = ConfigFile.new()
	
	var err = config.load(settings_cfg)
	
	if err != OK:
		print("There was an error loading the settings.cfg file")
		return
		
	most_recent_file_path = config.get_value("file_path", "most_recent_file_path")

## Sets contents in settings.cfg to be the new
## most recently used file path
## @params: path - new most recently used path
## @return: none
func set_most_recent_file_path(path):
	
	## Sets variable to most recent file path
	most_recent_file_path = path
	
	## Creates new Config file object
	var config = ConfigFile.new()
	
	## Stores the path 
	config.set_value("File", "most_recent_file_path", path)
	
	## Saves it to file (overwrites if already exists)
	config.save(settings_cfg)

## Project File Functions
## **********************************************************

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


## Saving Image Functions
## **********************************************************
func save_image_pix_desktop(image, path):
	
	## Open project file
	new_project_file(path)
	pix_dict = {
			"layer_0" : image.save_png_to_buffer()
	}
	json_string = JSON.stringify(pix_dict)
	project_file.store_line(json_string)
	project_file.close()
		
	set_most_recent_file_path(path)
	
func save_image_png_desktop(image, path):
	
	if path.ends_with(".png") == false:
		image.save_png(path+".png")
		set_most_recent_file_path(path+".png")
		
	else:
		image.save_png(path)
		set_most_recent_file_path(path)
	
## Opening Image Functions
## **********************************************************

## 
## @params:
## @return: none	
func show_open_image_file_dialog_desktop(file_dialog):
	file_dialog.set_filters(PackedStringArray(["*.pix ; PIX Files", "*.png ; PNG Images"]))
	file_dialog.set_current_path(most_recent_file_path)
	file_dialog.popup()
	
## Opens existing project file
## @params: path - file path where project is store
## @return: none
func open_pix_desktop(path):
	# open project file
	FileGlobals.open_project_file(path)
	json_string = FileGlobals.get_global_variable("project_file").get_line()
	json = JSON.new()
	json.parse(json_string)
	node_data = json.get_data()
	json.parse(node_data["layer_0"])
	array = json.get_data()
		
	# Load the file and image
	var image = Image.new()
		
	image.load_png_from_buffer(array)
	extract_path_and_image_info(path, image)
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")
	
## 
## @params: 
## path - file path where project is store
## 
## @return: none	
func open_png_desktop(path):
	# Load the file and image
	var image = Image.new()
	
	image.load(path)
	
	extract_path_and_image_info(path, image)
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

##
##
##
func extract_path_and_image_info(path, image):
	set_most_recent_file_path(path)
	get_opened_image_dimensions(image)
	
## 
## @params: 
## @return: none	
func get_opened_image_dimensions(image):
	CanvasGlobals.set_global_variable("image", image)
	CanvasGlobals.set_global_variable("canvas_size.x", image.get_width())
	CanvasGlobals.set_global_variable("canvas_size.y", image.get_height())
	
