## QUIT_BUTTON.GD
## ********************************************************************************
## Script for handling button presses that quit or terminate the application.
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

## Function called when the button is pressed. It instructs the game engine to quit
## or terminate the application.
## @params: none
## @return: none
func _on_pressed():
	## Quit or terminate the application
	get_tree().quit()
