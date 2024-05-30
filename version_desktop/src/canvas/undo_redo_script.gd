extends Node

## Holds past states of layer_images and item_list_names
## formatted as [ [[layer_images_t0], [layer_item_list_t0]],  [[layer_images_t1],  [layer_item_list_t1]] ...]
var undo_stack = []

## Holds future states of layer_images and item_list_names
## formatted as [ [[layer_images_t0], [layer_item_list_t0]],  [[layer_images_t1],  [layer_item_list_t1]] ...]
var redo_stack = []

## Reference to layer_item_list
@onready var layer_item_list = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/LayersPanelContainer/ScrollContainer/VBoxContainer/LayersMarginContainer/LayerItemList

## Adds current layer_images and item_list_names as a state to undo stack
## Called when drawing or modifying layers done
func add_to_undo_stack():
	print("adding to undo stack")


## Restores previous state from undo_stack
func undo():
	layer_item_list.get_item_names()
	print("undo")


## Restores next state from redo_stack
func redo():
	print("redo")
