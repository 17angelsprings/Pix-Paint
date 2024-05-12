extends Camera2D

@export var canvas_viewport: Control
@export var change_in_zoom: float

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

## Triggered when zoom in button pressed on workspace
## Calls zoom_io() with the set change_in_zoom and the focus set to (0,0) aka center
func _on_zoom_in_button_pressed():
	zoom_io(change_in_zoom, Vector2(0,0))

## Triggered when zoom out button pressed on workspace
## Calls zoom_io() with the set -change_in_zoom and the focus set to (0,0) aka center
func _on_zoom_out_button_pressed():
	zoom_io(-change_in_zoom, Vector2(0,0))
	
## Changes the camera's zoom by amount, centered on focus
## +amount = zoom in
## -amount = zoom out
func zoom_io(amount, focus):
	zoom += Vector2(amount,amount)
	offset = focus
