## MENU .GD
## ********************************************************************************
## Script for the Main Menu scene, which is presented when first opening Pix Paint
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

## Startup function that ensures necessary setup of anything that should happen 
## BEFORE the user takes any actions.
## @params: none
## @return: none
func _ready():
	## Retrieves default or last recently used file path from path.txt
	var file_path = FileGlobals.get_default_file_path()
	
	## path.txt only has "0" (Pix Paint installation is new)
	if file_path == "0":
		## File dialog for open
		var file_dialog = $HBoxContainer/VBoxContainer/OptionsMarginContainer/VBoxContainer/OpenButton/FileDialog
		
		## Obtains directory where the file dialog is
		var fd_dir = file_dialog.get_current_dir()
		
		## Removes characters from path returned in fd_dir to get directory above the file dialog's
		var default_dir = fd_dir.erase(fd_dir.length() - 8, 8)
		
		## Changes default path
		FileGlobals.set_default_file_path(default_dir)
		
		 ## Changes global file_path variable to new default path
		FileGlobals.set_global_variable("file_path", default_dir)
