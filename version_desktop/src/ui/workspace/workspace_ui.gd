## WORKSPACE UI.GD
## ********************************************************************************
## Script that handles interactions regarding the workspace UI itself.
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## workspace_ui.tcsn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Control
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************
## none
## ********************************************************************************

## FUNCTIONS
## ********************************************************************************

## If cursor is outside of canvas, revert back to default cursor
## @params: event - event detected when the user interacts with the element
## @return: none
func _input(event):
	if event is InputEventMouseMotion:
		Input.set_custom_mouse_cursor(null)
