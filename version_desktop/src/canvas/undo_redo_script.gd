## UNDO_REDO_SCRIPT .GD
## ********************************************************************************
## Script for undo/redo functionality
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## canvas.tscn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Holds past states of layer_images and item_list_names
## formatted as [ [[layer_images_t0], [layer_item_list_t0]],  [[layer_images_t1],  [layer_item_list_t1]] ...]
var undo_stack = []

## Holds future states of layer_images and item_list_names
## formatted as [ [[layer_images_t0], [layer_item_list_t0]],  [[layer_images_t1],  [layer_item_list_t1]] ...]
var redo_stack = []

## Reference to layer_item_list
@onready var layer_item_list = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/LayersPanelContainer/ScrollContainer/VBoxContainer/LayersMarginContainer/LayerItemList

## Reference to layer_manager
@onready var layer_manager = $"../layer_manager"

## For debugging use, counts number of state
var time :int

## FUNCTIONS
## ********************************************************************************

## Adds current layer_images and item_list_names as a state to undo stack
## Called when drawing or modifying layers done
## @params: none
## @return: none
func add_to_undo_stack():
	print("add_to_undo_stack() called")
	
	# make current state
	var curr_layer_images = duplicate_imag_array(CanvasGlobals.layer_images)
	var curr_item_names = layer_item_list.get_item_names()
	var curr_time = time
	time += 1
	var curr_state = [curr_layer_images, curr_item_names, time]
	if undo_stack.size() == 0 or curr_state != undo_stack[undo_stack.size() - 1]:
		undo_stack.append(curr_state)
		# every time a new pixel is placed, redo stack is cleared
		redo_stack.clear()
		print_s(undo_stack)


## Helper
## Creates a shallow copy of images array
## @params: images - array of Images
## #return: duplicate of images
func duplicate_imag_array(images):
	var duplicated_images = []
	for image in images:
		duplicated_images.append(image.duplicate())
	return duplicated_images


## Restores previous state from undo_stack
## @params: none
## @return: boolean value - undo success or failure
func undo():
	print("undo() called")
	if undo_stack.size() > 1:
		# add to redo stack
		redo_stack.append(undo_stack.pop_back())

		# get prev state
		var prev_state = undo_stack[undo_stack.size() - 1]
		print(prev_state)
		var prev_layer_images = prev_state[0]
		var prev_layer_names = prev_state[1]

		# print(prev_layer_images)
		# print(prev_layer_names)
		
		# make shallow copy of prev_layer_images so that drawing on them doesn't affect images in history
		var shallow_prev_images = duplicate_imag_array(prev_layer_images)
		
		# restore sprites + textures + sprites
		layer_manager.restore_layer_images(shallow_prev_images)
	
		# restore item list names
		layer_item_list.restore_item_names(prev_layer_names)

		return true
	return false


## Restores next state from redo_stack
## @params" none
## @return: boolean value - redo success or failure
func redo():
	print("redo() called")
	if redo_stack.size() > 0:
		# add to undo stack
		undo_stack.append(redo_stack.pop_back())

		# get next state
		var next_state = undo_stack[undo_stack.size() - 1]
		print(next_state)
		var next_layer_images = next_state[0]
		var next_layer_names = next_state[1]
		
		# make shallow copy of next_layer_images so that drawing on them doesn't affect images in history
		var shallow_next_images = duplicate_imag_array(next_layer_images)
		
		# restore sprites + textures + sprites
		layer_manager.restore_layer_images(shallow_next_images)

		# restore item list names
		layer_item_list.restore_item_names(next_layer_names)

		return true
	return false

## For debug: prints contents of stack seperated by newline
## @params: stack array
## @return: none
func print_s(stack):
	for state in stack:
		print(state)
