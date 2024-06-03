## FILE GLOBALS .GD (WEB VERSION)
## ********************************************************************************
## Script for global variables relating to the file I/O.
## ********************************************************************************

## CREDITS
## ********************************************************************************
## Web file I/O functions based on:
## https://github.com/Pukkah/HTML5-File-Exchange-for-Godot
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

var version_num = "1.0"

## When loading the canvas workspace is an image being opened, and if so is it a PIX file (1) or a PNG (2)?
var open_format = 0

signal read_completed

var js_callback = JavaScriptBridge.create_callback(open_handler)
var js_interface

var workspace_scene = "res://src_web/workspace_web/workspace.tscn"

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
## **************************************************************

## Looks up global variable value
## @params: var_name - name of global variable being looked up
## @return: any type of assignable value or none if global variable does not exist in this script
func get_global_variable(var_name):
	match var_name:
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

## Save Functions
## **************************************************************

func save_image_png_web(image, layer_images, file_name = project_name + ".png"):
	
	## Image that represents all layers
	var stacked_image = Image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
	for layer in layer_images:
		for x in layer.get_width():
			for y in layer.get_height():
				stacked_image.set_pixel(x, y, stacked_image.get_pixel(x, y).blend(layer.get_pixel(x, y)))

	## Save image
	var img_buffer = stacked_image.save_png_to_buffer()
	JavaScriptBridge.download_buffer(img_buffer, file_name)

## Opening Functions
## **************************************************************

## Initializes JS interace
## @params: none
## @return: none
func _ready():
	define_js()
	js_interface = JavaScriptBridge.get_interface("webFileExchange");

## Defines JS script for exhanging files via web
## @params: none
## @return: none
func define_js():

	JavaScriptBridge.eval("""
	var webFileExchange = {};
	webFileExchange.upload = function(gd_callback) {
		canceled = true;
		var input = document.createElement('INPUT'); 
		input.setAttribute("type", "file");
		input.setAttribute("accept", "image/png");
		input.click();
		input.addEventListener('change', event => {
			if (event.target.files.length > 0){
				canceled = false;}
			var file = event.target.files[0];
			var reader = new FileReader();
			this.fileType = file.type;
			// var fileName = file.name;
			reader.readAsArrayBuffer(file);
			reader.onloadend = (evt) => { // Since here's it's arrow function, "this" still refers to webFileExchange
				if (evt.target.readyState == FileReader.DONE) {
					this.result = evt.target.result;
					gd_callback(); // It's hard to retrieve value from callback argument, so it's just for notification
				}
			}
		  });
	}
	""", true)
	
## 
## @params: none
## @return: none
func open_handler(args):
	emit_signal("read_completed")

## 
## @params: none
## @return: none	
func open_image_web():
	js_interface.upload(js_callback);

	await self.read_completed
	
	var image_type = js_interface.fileType;
	var image_data = JavaScriptBridge.eval("webFileExchange.result", true)

	match image_type:
		"image/png":
			open_image_png_web(image_data)

		var invalidType:
			print("Unsupported file format - %s." % invalidType)
			return

## 
## @params: none
## @return: none	
func open_image_png_web(image_data):
	var layer_manager = $"/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager"
	## Load the image
	var image = Image.new()
	image.load_png_from_buffer(image_data)
	get_opened_image_dimensions(image)
	
	## Add layer
	layer_manager.add_layer_at(CanvasGlobals.current_layer_idx)
	CanvasGlobals.layer_images[CanvasGlobals.current_layer_idx] = image
	
	get_tree().change_scene_to_file(workspace_scene)

## 
## @params: 
## @return: none	
func get_opened_image_dimensions(image):
	CanvasGlobals.set_global_variable("image", image)
	CanvasGlobals.set_global_variable("canvas_size.x", image.get_width())
	CanvasGlobals.set_global_variable("canvas_size.y", image.get_height())
	
