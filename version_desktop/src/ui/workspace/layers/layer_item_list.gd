## LAYER_ITEMS_LIST .GD
## ********************************************************************************
## Script that handles how layers are displayed on the layers panel.
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## layers_panel_container.tcsn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends ItemList
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Layer manager node
@onready var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager

## Mouse grid node
@onready var mouse_grid = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid

var list_idx = 0

## Sets the layer 0 as currenlty selected layer
## @params: none
## @return: none
func _ready():
	if item_count == 0:
		select(0, true);
		list_idx = 0
	else:
		select(item_count - 1, true)
		list_idx = item_count - 1


## Returns list of item list names
## ordered from topmost layer to bottom most (opposite layer_manager order)
## @params: none
## @return: item_names - list of item list names
func get_item_names():
	var item_names = []
	for i in range(get_item_count()):
		item_names.append(get_item_text(i))
	return item_names


## Sets names in item-list
## @params: name_arr - item list to to have names set to
## @return: none
func set_item_names(name_arr):
	clear()
	for name in name_arr:
		add_item(name)


## Restores item names
## @params: prev_layer_names - names of layers to restore
## @return: none
func restore_item_names(prev_layer_names):
	## Get name of currently selected
		var selected_name = get_curr_selected_name()
		var selected_idx = (get_selected_items())[0]
		## Restore names
		set_item_names(prev_layer_names)
		if selected_name in prev_layer_names:
			## Reselect prev select
			select_item_by_name(selected_name)
			selected_idx = (get_selected_items())[0]
			update_item_list_indicies(selected_idx)
		else:
			## Selected layer is not in prev state, so need to select by idx
			select(selected_idx)
			update_item_list_indicies(selected_idx)


## Returns the name of the currently selected item
## @param: none
## @return: get_item_text(item_selected[0]) - item that is currently selected
func get_curr_selected_name():
	var item_selected = get_selected_items()
	return get_item_text(item_selected[0])


## Selects item by name
## Returns if success or failure
## @param: name - name of item selected
## @return: bool that indicates success/failure
func select_item_by_name(name):
	for i in range(get_item_count()):
		if get_item_text(i) == name:
			select(i)
			return true
	return false


## Called when item is selected
## @param: index - index of item in list
## @return: none
func _on_item_selected(index):
	update_item_list_indicies(index)


## Ipdates item list indices
## Seperate from on_item_selected bc when using select() instead of manual,
## on_item_selected is not called
## @param: index - index of item in list
## @return: none 
func update_item_list_indicies(index):
	## Layer manager in Canvas
	var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager	

	## Set current layer
	list_idx = index
	var lm_idx = (item_count - list_idx - 1)
	CanvasGlobals.current_layer_idx = lm_idx
	layer_manager.change_layer_to(lm_idx)


## Called when add layer is pressed
## @param: none
## @return: none
func _on_add_layer_button_pressed():
	add_layer()

## Adds layer
## @param: none
## @return: none
func add_layer():
	## Layer manager in Canvas
	var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager


	## Add new layer
	add_layer_helper()
	var lm_idx = (item_count - list_idx - 1)
	layer_manager.add_layer_at(lm_idx)

	## Set curr layer
	CanvasGlobals.current_layer_idx = lm_idx
	layer_manager.change_layer_to(lm_idx)

	## Add to undo stack
	mouse_grid.strokeControl()

## Housekeeping before adding the actual layer sprite; also used when opening a project file
## @param: none
## @return: none
func add_layer_helper():
	## Add item above currently selected layer
	## Set num layers
	var layer_num = CanvasGlobals.get_global_variable("num_layers")
	layer_num += 1
	CanvasGlobals.set_global_variable("num_layers", layer_num)

	## Add item to list
	var last_idx = add_item("Layer " + str(layer_num), null, true)
	move_item(last_idx, list_idx)
	select(list_idx, true)




## Called when delete layer is pressed
## @param: none
## @return: none
func _on_delete_layer_button_pressed():
	delete_layer()

## Deletes layer
## @param: none
## @return: none
func delete_layer():
	## Layer manager in Canvas
	var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager

	if item_count == 1:
		## If only one layer left, don't remove
		return
	else:
		## Delete layer
		var lm_idx = (item_count - list_idx - 1)
		layer_manager.delete_layer_at(lm_idx)

		## Set curr layer
		if CanvasGlobals.current_layer_idx > 0:
			CanvasGlobals.current_layer_idx -= 1
		layer_manager.change_layer_to(CanvasGlobals.current_layer_idx)

		## Update indices
		remove_item(list_idx)
		if list_idx == item_count:
			list_idx -= 1
		select(list_idx, true)

		## Update textures
		layer_manager.update_all_layer_textures()

		## Add to undo stack
		mouse_grid.strokeControl()
