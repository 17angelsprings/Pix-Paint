# Open BUTTON .GD
## ********************************************************************************
## Script that handles interaction with the Open Button
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

## Open file file dialog
@export var file_dialog: FileDialog

## Image to be opened
var image: Image
## ********************************************************************************

## FUNCTIONS
## ********************************************************************************

## Open button is pressed so opening proces begins
## @params: none
## @return: none
func _on_pressed():
	FileGlobals.show_open_image_file_dialog_desktop(file_dialog)

## Path is chosen in file dialog
## Begins file opening process
## @params: none
## @return: none
func _on_file_dialog_file_selected(path):
	
	if path.ends_with(".pix"):
		FileGlobals.open_format = 1
		get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

	elif path.ends_with(".png"):
		FileGlobals.open_format = 2
		get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

	FileGlobals.set_most_recent_file_path(path)
