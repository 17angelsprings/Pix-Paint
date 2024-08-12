## EXPORT BUTTON .GD
## ********************************************************************************
## Script that handles interaction with the Export Button
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

## Export button has been pressed so the export_pressed_button
## signal is true
## @params: none
## @return: none
func _on_pressed():
	FileGlobals.export_button_pressed = true
