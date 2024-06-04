## HOVER_EFFECT .GD
## ********************************************************************************
## Script for mouse hover effect
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node2D
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Size of pixel
var pixel_size = 1

## Size of grid
var tool_size = 1

## Mouse position
var mouse_pos = Vector2()

## Color of mouse hover
var color = Color(0.0, 0.0, 0.0, 0.0)

## FUNCTIONS
## ********************************************************************************

## Initialize hover effect
## @params: none
## @return: none
func _ready():
	set_process_input(true)

## Handles mouse input
## @params: event - an interaction or signal to the canvas
## @return: none
func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		#queue_redraw()

## Updates size of hover according to the brush and eraser size
## @params: none
## @return: none
func update_hover():
	if ToolGlobals.get_global_variable("brush_eraser"):
		tool_size = ToolGlobals.eraser_size
	else:
		tool_size = ToolGlobals.brush_size

## Hover effect
## @params: none
## @return: none
func _draw():
	update_hover()
	var grid_pos = (mouse_pos / pixel_size).floor() * pixel_size  # Align with the pixel grid
	var hover_center = grid_pos + Vector2(pixel_size / 2, pixel_size / 2)  # Calculate the center of the hover effect

	# Adjust for odd brush sizes
	if int(tool_size) % 2 != 0:
		hover_center += Vector2(0.5, 0.5)

	var hover_rect = Rect2(hover_center - Vector2(tool_size / 2, tool_size / 2), Vector2(tool_size, tool_size))

	draw_rect(hover_rect, color)

## Called every frame. 'delta' is the elapsed time since the previous frame.
## @params: delta
## @return: none
func _process(_delta):
	# Get the global mouse position
	var mouse_pos = get_global_mouse_position()

	# Check if mouse is within canvas bounds
	if mouse_pos.x >= 0 and mouse_pos.x <= CanvasGlobals.canvas_size.x and mouse_pos.y >= 0 and mouse_pos.y <= CanvasGlobals.canvas_size.y:
		#print("Mouse is within the canvas.")
		color = Color(0.7, 0.7, 0.7, 0.7)
		queue_redraw()

	else:
		color = Color(0.0, 0.0, 0.0, 0.0)
		queue_redraw()
		#print("Mouse is outside the canvas.")




