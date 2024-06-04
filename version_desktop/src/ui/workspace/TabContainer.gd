# TAB CONTAINER .GD
## ********************************************************************************
## Script for handling state of the tool tab container.
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## tools_panel_container.tcsn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends TabContainer

## SCRIPT-WIDE VARIABLES
## ********************************************************************************
## none
## ********************************************************************************

## FUNCTIONS
## ********************************************************************************

# Changes the brush_eraser global variable to reflect whether the brush 
## or eraser is selected
## @params: tab - selected tab
## @returns: none
func _on_tab_clicked(tab):
	ToolGlobals.set_global_variable("brush_eraser", tab)
