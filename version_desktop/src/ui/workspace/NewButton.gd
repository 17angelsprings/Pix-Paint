# NEW BUTTON .GD
## ********************************************************************************
## Script that handles interaction and functionality of the New button
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## workspace_ui.tcsn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************
## none
## ********************************************************************************

## FUNCTIONS
## ********************************************************************************

## New button has been pressed so the scene changes
## to the New Canvas scene
## @params: none
## @return: none
func _on_pressed():
	CanvasGlobals.set_global_variable("image", Image.create(CanvasGlobals.get_global_variable("canvas_size.x"), CanvasGlobals.get_global_variable("canvas_size.y"), false, Image.FORMAT_RGBA8))
	get_tree().change_scene_to_file("res://src/ui/menu/new_canvas.tscn")
