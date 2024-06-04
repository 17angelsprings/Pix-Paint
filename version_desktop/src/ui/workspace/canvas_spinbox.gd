## CANVAS_SPINBOX.GD
## ********************************************************************************
class_name CanvasSpinbox
## Class script for spinboxes that resize the canvas.
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## canvas_panel_container.tcsn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends SpinBox
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Global variable for width or height of canvas
@export var global_var: String
## ********************************************************************************

## FUNCTIONS
## ********************************************************************************

## Initializes width and height of canvas when Canvas node enters scene
## @params: none
## @return: none
func _ready():
	value = CanvasGlobals.get_global_variable(global_var)
	CanvasGlobals.set_global_variable(global_var, value)

## Changes width or height of canvas 
## @params: value_picked - new width or height
## @return: none
func _on_value_changed(value_picked):
	CanvasGlobals.set_global_variable(global_var, value_picked)
