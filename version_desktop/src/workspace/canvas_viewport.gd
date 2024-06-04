## CANVAS_VIEWPORT .GD
## ********************************************************************************
## Script that handles modifications to the size of the canvas viewport.
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## canvas_viewport.tscn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Control
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Subviewport container
@export var subviewcontainer: SubViewportContainer

## Subviewport
@export var subviewport: SubViewport

## Camera subviewport container
@export var camerasubviewcontainer: SubViewportContainer

## Camera subviewport
@export var camerasubviewport: SubViewport

## Canvas camera
@export var canvas_camera: Camera2D

## Zoom-in button
@export var zoom_in_button: Button

## Zoom-out button
@export var zoom_out_button: Button

## ********************************************************************************

## FUNCTIONS
## ********************************************************************************

## Connects the canvas global variables to the canvas viewport
## @params: none
## @return: none
func _ready():
	var canvas_global_script = get_node("/root/CanvasGlobals")
	if canvas_global_script:
		print("canvas_globals connected to viewport")
		canvas_global_script.connect("canvas_size_changed", _on_canvas_size_changed)
	update_canvas_size()

## Calls update_canvas_size and prints an acknowledgement
## @params: none
## @return: none
func _on_canvas_size_changed():
	print("Canvas Size Changed")
	update_canvas_size()

## Updates canvas size
## @params: none
## @return: none
func update_canvas_size():
	## Set viewport size to match canvas
	subviewport.size_2d_override = CanvasGlobals.canvas_size
	## Camerasubviewport.size_2d_override = CanvasGlobals.canvas_size

	## Set container size
	if CanvasGlobals.canvas_size.x == CanvasGlobals.canvas_size.y:
		subviewcontainer.size.x = 500
		subviewcontainer.size.y = 500

	## If width is bigger, x should be 600 and y should scale according to canvas size
	elif CanvasGlobals.canvas_size.x > CanvasGlobals.canvas_size.y:
		subviewcontainer.size.x = 500
		subviewcontainer.size.y = (500 * CanvasGlobals.canvas_size.y)/CanvasGlobals.canvas_size.x

	## If length is bigger, y should be 600 and x should scale according to canvas size
	else:
		subviewcontainer.size.y = 500
		subviewcontainer.size.x = (500 * CanvasGlobals.canvas_size.x)/CanvasGlobals.canvas_size.y

	## Set container position, so that the canvas stays centered
	subviewcontainer.position.x = -(subviewcontainer.size.x/2)
	subviewcontainer.position.y = -(subviewcontainer.size.y/2)

	print("SubViewport Size: ", subviewport.size_2d_override)
	print("SubViewContainer Size: ", subviewcontainer.size)
