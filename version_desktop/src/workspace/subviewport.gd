## SUBVIEWPORT. GD
## ********************************************************************************
## Script for handling zoom functionality via mouse wheel scrolls.
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends SubViewport
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## References canvas_camera
@export var canvas_camera: Camera2D

## Mouse position
var mouse_pos

## ********************************************************************************

## FUNCTIONS
## ********************************************************************************

## Used to detect mouse interaction for mouse
## @params: event - an interaction or signal to the canvas
## @return: none
func _input(event):	
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		print(mouse_pos)
	elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		canvas_camera.offset += (mouse_pos - Vector2(50,50)/Vector2(canvas_camera.zoom))
		canvas_camera.zoom_io(canvas_camera.change_in_zoom, canvas_camera.offset)
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		canvas_camera.offset -= (mouse_pos - Vector2(50,50)/Vector2(canvas_camera.zoom))
		canvas_camera.zoom_io(-canvas_camera.change_in_zoom, canvas_camera.offset)
