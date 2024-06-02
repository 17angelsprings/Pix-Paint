## NEW_CANVAS .GD
## ********************************************************************************
## Script for the New Canvas scene, which allows users to create a new project or
## cancel and return to the previous scene or the main menu
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Control
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************
var workspace_scene = "res://src_web/workspace_web/workspace.tscn"
var menu_scene = "res://src_web/ui_web/menu_web/menu.tscn"
## ********************************************************************************


## FUNCTIONS
## ********************************************************************************

## Function called when the OK button is pressed. It sets up the project name and image,
## then proceeds to the Workspace scene.
## OK button is pressed -> proceed to Workspace
## @params: none
## @return: none
func _on_ok_pressed():
	## Retreive the text from LineEdit control
	var project_name = $HBoxContainer/VBoxContainer/FileNameMarginContainer/HBoxContainer/LineEdit.get_text()

	## Default the project name to "project" if no name is provided
	if project_name == "":
		project_name = "project"

	## Store the project name in global variables
	FileGlobals.set_global_variable("project_name", project_name)
 
	## Create a new image with the specified canvas size and format	
	var image = Image.create(CanvasGlobals.get_global_variable("canvas_size.x"), CanvasGlobals.get_global_variable("canvas_size.y"), false, Image.FORMAT_RGBA8)

	## Store the image in global variables
	CanvasGlobals.set_global_variable("image", image)

	## Change the scene to the Workspace scene
	get_tree().change_scene_to_file(workspace_scene)

## Function called when the Cancel button is pressed. It navigates back to the Main 
## Menu or returns to the previous Workspace state.
## @params: none
## @return: none
func _on_cancel_pressed():
	## Check if the user accessed from the Workspace
	if FileGlobals.get_global_variable("accessed_from_workspace") == false:

		## Navigate to the Main Menu scene
		get_tree().change_scene_to_file(menu_scene)
	else:
		restorePreviousCanvas()

		## Navigate back to the Workspace scene
		get_tree().change_scene_to_file(workspace_scene)

## Restores previous canvas from before you accessed New Canvas
## @params: none
## @return: none		
func restorePreviousCanvas():
	## Retrieve previous canvas size and image from global variables
	var prev_x = CanvasGlobals.get_global_variable("prev_canvas_size.x")
	var prev_y = CanvasGlobals.get_global_variable("prev_canvas_size.y")

	## Restore previous canvas size
	CanvasGlobals.set_global_variable("canvas_size.x", prev_x)
	CanvasGlobals.set_global_variable("canvas_size.y", prev_y)

	## Restore the previous image
	CanvasGlobals.set_global_variable("image", CanvasGlobals.get_global_variable("prev_image"))
