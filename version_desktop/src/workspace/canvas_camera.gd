extends Camera2D

signal zoom_changed(new_zoom)

@export var canvas_viewport: Control
@export var change_in_zoom: float

## seperate value for zoom needed to be able to detect change in zoom
var camera_zoom = Vector2(1.0,1.0):
	set = camera_zoom_changed

## Connect to zoom buttons in workspace to camera
func _ready():
	var zoom_in_button_node = canvas_viewport.zoom_in_button
	var zoom_out_button_node = canvas_viewport.zoom_out_button
	if zoom_in_button_node:
		print("zoom in button connected to camera")
		zoom_in_button_node.connect("pressed", _on_zoom_in_button_pressed)
	if zoom_out_button_node:
		print("zoom out button connected to camera")
		zoom_out_button_node.connect("pressed", _on_zoom_out_button_pressed)

## Triggered when camera_zoom value is set
## new_zoom is the new value of camera_zoom
## Updates zoom value and emits signal
func camera_zoom_changed(new_zoom):
	if (new_zoom > Vector2(0,0)):
		camera_zoom = new_zoom
		zoom = camera_zoom
		emit_signal("zoom_changed", camera_zoom)

## Triggered when zoom in button pressed on workspace
## Calls zoom_io() with the set change_in_zoom and the focus set to (0,0) aka center
func _on_zoom_in_button_pressed():
	zoom_io(change_in_zoom, offset)

## Triggered when zoom out button pressed on workspace
## Calls zoom_io() with the set -change_in_zoom and the focus set to (0,0) aka center
func _on_zoom_out_button_pressed():
	zoom_io(-change_in_zoom, offset)
	
## Changes the camera's zoom by amount, centered on focus
## +amount = zoom in
## -amount = zoom out
func zoom_io(amount, focus):
	camera_zoom += Vector2(amount,amount)
	offset = focus
