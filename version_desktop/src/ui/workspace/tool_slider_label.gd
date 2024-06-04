## TOOL_SLIDER_LANEL .GD
## ********************************************************************************
class_name LabeledSlider
## Class script for determing what is displayed on the label for sliders,
## specifically for the brush and eraser.
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Label
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Horizonal slider
@export var slider: HSlider

## Prefix
@export var prefix: String

## Global variable (size/opacity of brush/eraser)
@export var global_var: String

## Label text
var label_text

## FUNCTIONS
## ********************************************************************************

## Initializes lables
## @params: none
## @return: none
func _ready():
	label_text = prefix + str(slider.value)
	text = label_text
	ToolGlobals.set_global_variable(global_var, slider.value)

	slider.value_changed.connect(_update_label_text)

## Changes what number the label displays
## @params: value - value to change size or opacity too
## @return: none
func _update_label_text(value):
	label_text = prefix + str(value)
	text = label_text
	ToolGlobals.set_global_variable(global_var, value)
