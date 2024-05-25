## WEBFILE GLOBALS .GD  
##**************************************************************************
## Script file with functions for handling File I/O specifically for the web
##**************************************************************************

## CREDITS  
##**************************************************************************
## https://github.com/Pukkah/HTML5-File-Exchange-for-Godot
##**************************************************************************


## EXTENSIONS  
##**************************************************************************
extends Node
##**************************************************************************

## SCRIPT-WIDE VARIABLES
##**************************************************************************

signal read_completed

var js_callback = JavaScriptBridge.create_callback(open_handler)
var js_interface

var workspace_scene = "res://src_web/workspace_web/workspace.tscn"

## For parsing/saving a project file
var json_string
var json
var node_data
var array
var pix_dict
##**************************************************************************

## FUNCTIONS
##**************************************************************************

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
		input.setAttribute("accept", "image/png, image/pix");
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

func open_handler(args):
	emit_signal("read_completed")
	
func open_image():
	js_interface.upload(js_callback);

	await self.read_completed
	
	var image_type = js_interface.fileType;
	var image_data = JavaScriptBridge.eval("webFileExchange.result", true) # interface doesn't work as expected for some reason
	
	var image = Image.new()
	var image_error
	match image_type:
		"image/png":
			image_error = open_image_png(image, image_data)
		"image/pix":
			image_error = open_image_pix(image, image_data)
		var invalidType:
			print("Unsupported file format - %s." % invalidType)
			return
	
	if image_error:
		print("An error occurred while trying to display the image.")
	
	FileGlobals.get_opened_image_dimensions(image)
	get_tree().change_scene_to_file(workspace_scene)
	
func open_image_png(image, image_data):
	return image.load_png_from_buffer(image_data)
	
func open_image_pix(image, image_data):
	json = JSON.new()
	json.parse(json_string)
	node_data = json.get_data()
	json.parse(node_data["layer_0"])
	array = json.get_data()
	return image.load_png_from_buffer(array)

func save_image_png(image, file_name = FileGlobals.project_name + ".png"):
	var buffer = image.save_png_to_buffer()
	JavaScriptBridge.download_buffer(buffer, file_name)
	
func save_image_pix(image, file_name = FileGlobals.project_name + ".pix"):
	FileGlobals.pix_dict = {
			"layer_0" : image.save_png_to_buffer()
	}
	FileGlobals.json_string = JSON.stringify(FileGlobals.pix_dict)
	FileGlobals.project_file.store_line(FileGlobals.json_string)
	FileGlobals.project_file.close()
