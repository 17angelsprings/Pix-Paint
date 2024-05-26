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

## FUNCTIONS
## ********************************************************************************

## Canvas base
func _draw():
	
	## Alternating squares
	for y in range(int(CanvasGlobals.canvas_size.y / pixel_size)):
		for x in range(int(CanvasGlobals.canvas_size.x / pixel_size)):
			if (x + y) % 2 == 0:
				draw_rect(Rect2(x * pixel_size, y * pixel_size, pixel_size, pixel_size), Color(0.9, 0.9, 0.9))
			else:
				draw_rect(Rect2(x * pixel_size, y * pixel_size, pixel_size, pixel_size), Color(0.8, 0.8, 0.8))
