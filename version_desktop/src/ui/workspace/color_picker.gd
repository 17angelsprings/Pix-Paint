## COLOR_PICKER .GD
## ********************************************************************************
## Class script the color picker.
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## canvas_panel_container.tcsn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends ColorPicker
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************
## none
## ********************************************************************************


## FUNCTIONS
## ********************************************************************************

## Initializes brush color to black when Canvas node is first opened up
## @params: none
## @return: none
func _ready():
	color = Color(0.0 , 0.0, 0.0);
	ToolGlobals.set_global_variable("brush_color", color)

## Changes brush color
## @params: color_picked - new color for brush
## @return: none
func _on_color_changed(color_picked):
	ToolGlobals.set_global_variable("brush_color", color_picked)

