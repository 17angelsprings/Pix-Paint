## TOOL GLOBALS .GD
## ********************************************************************************
## Script for global variables relating to drawing tools (pen/eraser)
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Pen/eraser toggle
## 0 is pen; 1 is eraser
## 0 by default
var pen_eraser: bool = 0

## Pen size
var pen_size

## Pen opacity
var pen_opacity

## Pen color
var pen_color

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
		"pen_eraser":
			return pen_eraser
		"pen_size":
			return pen_size
		"pen_opacity":
			return pen_opacity
		"pen_color":
			return pen_color
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
	print(value)
	match var_name:
		"pen_eraser":
			pen_eraser = value
		"pen_size":
			pen_size = value
		"pen_opacity":
			pen_opacity = value
		"pen_color":
			pen_color = value
		"eraser_size":
			eraser_size = value
		"eraser_opacity":
			eraser_opacity = value
		_:
			print("Unknown global variable:", var_name)
