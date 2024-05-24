## CANVAS_GLOBALS .GD
## ********************************************************************************
## Script for global variables relating to the canvas
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Signal to indicate canvas size changed
signal canvas_size_changed

## Image variable that stores the image from which the canvas will be created from
## Blank image by default but will be overwritted by a loaded image if applicable
var image

## Previous image
## Stores most recent image on the workspace during a work session so that user may
## still have the image they were working on even if they didn't save first before
## taking another action such as opening a new canvas and then cancelling it
var prev_image

## Invisible image that protects opacity / blend properties
var invisible_image : Image

## Canvas size
## 100 x 100 px by default
var canvas_size = Vector2(100.0, 100.0):
	## When canvas changes, set_canvas_size is called
	set = set_canvas_size

## Current layer index	
var current_layer_idx

## Previous canvas size
## 100 x 100 px by default
var prev_canvas_size = Vector2(100.0, 100.0)


## Undo / redo flags
var undo_button_pressed = false
var redo_button_pressed = false
## ********************************************************************************

## FUNCTIONS
## ********************************************************************************

## Emits a signal when canvas size has changed so other nodes can react to the change
## @params: new_val - new value canvas size changed to
## @return: none
func set_canvas_size(new_val):
	canvas_size_changed.emit()

## Looks up global variable value
## @params: var_name - name of global variable being looked up
## @return: any type of assignable value or none if global variable does not exist in this script
func get_global_variable(var_name):
	match var_name:
		"image":
			return image
		"prev_image":
			return prev_image
		"current_layer_idx":
			return current_layer_idx
		"canvas_size.x":
			return canvas_size.x
		"canvas_size.y":
			return canvas_size.y
		"prev_canvas_size.x":
			return prev_canvas_size.x
		"prev_canvas_size.y":
			return prev_canvas_size.y
		"undo_button_pressed":
			return undo_button_pressed
		"redo_button_pressed":
			return redo_button_pressed
		_:
			print("Unknown global variable:", var_name)

## Sets global variable value
## @params: 
## var_name - name of global variable to change
## value - value to change specified global variable to
## @return: none
func set_global_variable(var_name, value):
	match var_name:
		"image":
			image = value
		"prev_image":
			prev_image = value
		"current_layer_idx":
			current_layer_idx = value
		"canvas_size.x":
			canvas_size.x = value
		"canvas_size.y":
			canvas_size.y = value
		"prev_canvas_size.x":
			prev_canvas_size.x = value
		"prev_canvas_size.y":
			prev_canvas_size.y = value
		"undo_button_pressed":
			undo_button_pressed = value
		"redo_button_pressed":
			redo_button_pressed = value
		_:
			print("Unknown global variable:", var_name)

## Resets invisible image
## @params: none
## @return: none
func reset_invisible_image():
	invisible_image = Image.create(get_global_variable("canvas_size.x"), get_global_variable("canvas_size.y"), false, Image.FORMAT_RGBA8)

## Checks if pixel is locked
## @params: 
## posx - x-coordinate of pixel at position
## posy - y-coordinate of pixel at position
## @return: boolean value - indicates if pixel if locked or not
func invisible_image_green_light(posx, posy):
	return invisible_image.get_pixel(posx, posy) == Color(0,0,0,0)
	
## Locks a pixel
## @params: 
## posx - x-coordinate of pixel at position
## posy - y-coordinate of pixel at position
## @return: none
func invisible_image_red_light(posx, posy):
	invisible_image.set_pixel(posx, posy, Color.TRANSPARENT)
