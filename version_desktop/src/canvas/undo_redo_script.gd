extends Node

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

## Adds current layer_images and item_list_names as a state to undo stack
## Called when drawing or modifying layers done
func add_to_undo_stack():
	print("add_to_undo_stack() called")
	# print(undo_stack)
	# make current state
	var curr_layer_images = duplicate_layer_images()
	var curr_item_names = layer_item_list.get_item_names()
	var curr_state = [curr_layer_images, curr_item_names]
	if undo_stack.size() == 0 or curr_state != undo_stack[undo_stack.size() - 1]:
		undo_stack.append(curr_state)
		# every time a new pixel is placed, redo stack is cleared
		redo_stack.clear()
		print(undo_stack)


## Helper for add_to_undo_stack()
## Creates a shallow copy of layer_images
func duplicate_layer_images():
	var duplicated_images = []
	for image in CanvasGlobals.layer_images:
		duplicated_images.append(image.duplicate())
	return duplicated_images


## Restores previous state from undo_stack
## Returns if success or failure
func undo():
	print("undo() called")
	if undo_stack.size() > 1:
		# add to redo stack
		redo_stack.append(undo_stack.pop_back())
		
		# get prev state
		var prev_state = undo_stack[undo_stack.size() - 1]
		var prev_layer_images = prev_state[0]
		var prev_layer_names = prev_state[1]
		print(prev_layer_images)
		print(prev_layer_names)
		
		# restore sprites + textures + sprites
		layer_manager.restore_layer_images(prev_layer_images)
		
		# restore item list names
		layer_item_list.restore_item_names(prev_layer_names)
		
		return true
	return false


## Restores next state from redo_stack
## Returns if success or failure
func redo():
	print("redo() called")
	if redo_stack.size() > 0:
		# add to undo stack
		undo_stack.append(redo_stack.pop_back())
		
		# get next state
		var next_state = undo_stack[undo_stack.size() - 1]
		var next_layer_images = next_state[0]
		var next_layer_names = next_state[1]
		
		# restore sprites + textures + sprites
		layer_manager.restore_layer_images(next_layer_images)
		
		# restore item list names
		layer_item_list.restore_item_names(next_layer_names)
		
		return true
	return false
