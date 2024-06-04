## BACK BUTTON.GD
## ********************************************************************************
## Script for handling button presses that quit or terminate the application.
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## creds_perms.tcsn
## help.tcsn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Button
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Path to main menu scene
var menu_scene = "res://src/ui/menu/menu.tscn"


## FUNCTIONS
## ********************************************************************************

## Changes scene back to main menu when pressed
## @params: none
## @return: none
func _on_pressed():
	## Navigate to the Main Menu scene
	get_tree().change_scene_to_file(menu_scene)
