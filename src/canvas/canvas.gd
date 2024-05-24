## CANVAS .GD
## ********************************************************************************
## Script for canvas properties
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

## Canvas size variables
var canvas_width = CanvasGlobals.canvas_size.x
var canvas_height = CanvasGlobals.canvas_size.y

## FUNCTIONS
## ********************************************************************************

## Initialize hover effect
func _ready():
	set_process_input(true)

## Handles mouse input
func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		queue_redraw()

## Updates size of hover according to the brush and eraser size
func update_hover():
	if ToolGlobals.get_global_variable("brush_eraser"):
		tool_size = ToolGlobals.eraser_size
	else:
		tool_size = ToolGlobals.brush_size

## Canvas base + hover effect
func _draw():
	update_hover()
	var grid_pos = (mouse_pos / pixel_size).floor() * pixel_size  # Align with the pixel grid
	var hover_center = grid_pos + Vector2(pixel_size / 2, pixel_size / 2)  # Calculate the center of the hover effect
	
	# Adjust for odd brush sizes
	if int(tool_size) % 2 != 0:
		hover_center += Vector2(0.5, 0.5)
	
	var hover_rect = Rect2(hover_center - Vector2(tool_size / 2, tool_size / 2), Vector2(tool_size, tool_size))
	
	draw_rect(hover_rect, Color(0.2, 0.2, 0.2, 0.8))
	
	## Alternating squares
	for y in range(int(CanvasGlobals.canvas_size.y / pixel_size)):
		for x in range(int(CanvasGlobals.canvas_size.x / pixel_size)):
			if (x + y) % 2 == 0:
				draw_rect(Rect2(x * pixel_size, y * pixel_size, pixel_size, pixel_size), Color(0.9, 0.9, 0.9))
			else:
				draw_rect(Rect2(x * pixel_size, y * pixel_size, pixel_size, pixel_size), Color(0.8, 0.8, 0.8))
