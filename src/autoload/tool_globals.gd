## TOOL GLOBALS .GD
## ********************************************************************************
## Script for global variables relating to drawing tools (brush/eraser)
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Brush/eraser toggle
## 0 is brush; 1 is eraser
## 0 by default
var brush_eraser: bool = 0

## Brush size
var brush_size

## Brush opacity
var brush_opacity

## Brush color
var brush_color

## Eraser size
var eraser_size

## Eraser opacity
var eraser_opacity

## FUNCTIONS
## ********************************************************************************

## Looks up global variable value
## @params: var_name - name of global variable being looked up
## @return: any type of assignable value or none if global variable does not exist in this script
func get_global_variable(var_name):
	match var_name:
		"brush_eraser":
			return brush_eraser
		"brush_size":
			return brush_size
		"brush_opacity":
			return brush_opacity
		"brush_color":
			return brush_color
		"eraser_size":
			return eraser_size
		"eraser_opacity":
			return eraser_opacity
		_:
			print("Unknown global variable:", var_name)

## Sets global variable value
## @params: 
## var_name - name of global variable to change
## value - value to change specified global variable to
## @return: none
func set_global_variable(var_name, value):
	print("trying to set to ", value)
	match var_name:
		"brush_eraser":
			brush_eraser = value
		"brush_size":
			brush_size = value
		"brush_opacity":
			brush_opacity = value
		"brush_color":
			brush_color = value
		"eraser_size":
			eraser_size = value
		"eraser_opacity":
			eraser_opacity = value
		_:
			print("Unknown global variable:", var_name)
