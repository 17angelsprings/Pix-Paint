## UNDO BUTTON.GD
## ********************************************************************************
## Script that handles interaction with the Undo button.
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## canvas_panel_container.tcsn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Button
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************
## none
## ********************************************************************************

## FUNCTIONS
## ********************************************************************************

## Undo button has been pressed so undo_button_pressed signal is true
## @params: event - event detected when the user interacts with the element
## @return: none
func _on_pressed():
	CanvasGlobals.set_global_variable("undo_button_pressed", true)
