## NEXT_SCENE_BUTTON .GD
## ********************************************************************************
## Script for handling button presses that transition to a new scene. This is useful
## for navigating to different parts of the application, such as moving from a menu
## to the workspace or other scenes.
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Button
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************
@export var next_scene: String 
## ********************************************************************************


## FUNCTIONS
## ********************************************************************************

## Function called when the button is pressed. It prints a message to the console
## and changes the scene to the one specified by the next_scene variable.
## @params: none
## @return: none
func _on_pressed():
	## Print a debug message to the console
	print("Next scene")
	
	## Change the current scene to the scene specified by next_scene
	get_tree().change_scene_to_file(next_scene)
