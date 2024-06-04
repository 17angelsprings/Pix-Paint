## FILE GLOBALS .GD
## ********************************************************************************
## Script for global variables relating to the file I/O and images
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## none
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Pix Paint program version number
var version_num = "1.0"

## Settings config file
var settings_cfg = "user://settings.cfg"

## Most recently accessed file path
var most_recent_file_path

## When loading the canvas workspace is an image being opened, and if so is it a PIX file (1) or a PNG (2)?
var open_format = 0

## Project file
var project_file: FileAccess

## For parsing/saving a project file
var json_string
var json
var image_buffer
var pix_dict = {}

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

## Creates new Config file object
## @params: none
## @return: none
func file_path_init():
	var config = ConfigFile.new()

	get_most_recent_file_path()

	print(most_recent_file_path)

	if most_recent_file_path == null:
		var first_path = OS.get_executable_path().get_base_dir() + "/"
		set_most_recent_file_path(first_path)

## Retrieves path stored in settings.cfg
## It is the most recently used file path
## @params: none
## @return: most_recent_file_path - most recently used file path
func get_most_recent_file_path():

	## Creates new Config file object
	var config = ConfigFile.new()

	var err = config.load(settings_cfg)

	if err != OK:
		print("There was an error loading the settings.cfg file")
		return

	most_recent_file_path = config.get_value("File", "most_recent_file_path")

	return most_recent_file_path

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

## Saves an image as a .PIX file to the specified path
## @params: image, path
## @return: none
func save_image_pix_desktop(image, path):

	## Open project file
	new_project_file(path)

	# Clear dictionary
	pix_dict.clear()

	# Write each layer's data
	for i in range(CanvasGlobals.layer_images.size()):
		pix_dict["layer_" + str(i)] = CanvasGlobals.layer_images[i].save_png_to_buffer()
	json_string = JSON.stringify(pix_dict)
	project_file.store_line(json_string)
	project_file.close()

	set_most_recent_file_path(path)

## Saves an image as a .PNG file to the specified path
## @params: image, path, layer_images - array of layers
## @return: none
func save_image_png_desktop(image, path, layer_images):

	if path.ends_with(".png") == false:
		path = path + ".png"

	# Image that represents all layers
	var stacked_image = Image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
	for layer in layer_images:
		for x in layer.get_width():
			for y in layer.get_height():
				stacked_image.set_pixel(x, y, stacked_image.get_pixel(x, y).blend(layer.get_pixel(x, y)))


	# Save image
	stacked_image.save_png(path)
	set_most_recent_file_path(path)

## Opening Image Functions
## **********************************************************

## Shows the Open File dialog to user
## @params: file_dialog
## @return: none	
func show_open_image_file_dialog_desktop(file_dialog):
	file_dialog.set_filters(PackedStringArray(["*.pix ; PIX Files", "*.png ; PNG Images"]))
	file_dialog.set_current_path(most_recent_file_path)
	file_dialog.popup()

## Opens existing project file in specified path
## @params: path
## @return: none
func open_pix_desktop(path):

	# layer item list in layer panels UI
	var LayerItemList = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/LayersPanelContainer/ScrollContainer/VBoxContainer/LayersMarginContainer/LayerItemList

	# layer manager in Canvas
	var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager

	# open project file
	open_project_file(path)

	# load layer dictionary
	json_string = project_file.get_line()
	json = JSON.new()
	json.parse(json_string)
	pix_dict = json.get_data()

	# get canvas dimensions
	json.parse(pix_dict["layer_0"])
	image_buffer = json.get_data()
	var image = Image.new()
	image.load_png_from_buffer(image_buffer)
	extract_path_and_image_info(path, image)	


	# load layers
	for i in range(pix_dict.keys().size()):
		# add a new layer
		LayerItemList.add_layer_helper()
		layer_manager.add_layer_at(i)
		layer_manager.add_layer_at(i)

		# get layer information
		json.parse(pix_dict["layer_" + str(i)])
		image_buffer = json.get_data()
		image = Image.new()
		image.load_png_from_buffer(image_buffer)

		# set layer
		CanvasGlobals.layer_images[i] = image

	# set current layer
	LayerItemList.select(LayerItemList.item_count - 1, true)
	LayerItemList.list_idx = LayerItemList.item_count - 1 
	CanvasGlobals.current_layer_idx = LayerItemList.item_count - 1

## Opens existing PNG file in specified path
## @params: path
## @return: none	
func open_png_desktop(path):
	
	## Layer manager in Canvas
	var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager

	## Load the file and image
	var image = Image.new()
	image.load(path)
	extract_path_and_image_info(path, image)

	## Add layer
	layer_manager.add_layer_at(CanvasGlobals.current_layer_idx)
	CanvasGlobals.layer_images[CanvasGlobals.current_layer_idx] = image


## Sets most recent file path and extracts image dimensions
## @params:
## path - most recent file path 
## image - image to get dimensions from
## @return: none
func extract_path_and_image_info(path, image):
	set_most_recent_file_path(path)
	get_opened_image_dimensions(image)

## Extracts image width and height
## @params: image - image to get dimensions from
## @return: none	
func get_opened_image_dimensions(image):
	CanvasGlobals.set_global_variable("image", image)
	CanvasGlobals.set_global_variable("canvas_size.x", image.get_width())
	CanvasGlobals.set_global_variable("canvas_size.y", image.get_height())

