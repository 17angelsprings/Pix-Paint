extends ItemList

@onready var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager
@onready var mouse_grid = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid

var list_idx = 0

## Sets the layer 0 as currenlty selected layer
func _ready():
	if item_count == 0:
		select(0, true);
		list_idx = 0
	else:
		select(item_count - 1, true)
		list_idx = item_count - 1


## Returns list of item list names
## ordered from topmost layer to bottom most (opposite layer_manager order)
func get_item_names():
	var item_names = []
	for i in range(get_item_count()):
		item_names.append(get_item_text(i))
	return item_names


## Sets names in item list
func set_item_names(name_arr):
	clear()
	for name in name_arr:
		add_item(name)


## Restores item names
func restore_item_names(prev_layer_names):
	# get name of currently selected
		var selected_name = get_curr_selected_name()
		var selected_idx = (get_selected_items())[0]
		# restore names
		set_item_names(prev_layer_names)
		if selected_name in prev_layer_names:
			# reselect prev select
			select_item_by_name(selected_name)
			selected_idx = (get_selected_items())[0]
			update_item_list_indicies(selected_idx)
		else:
			# selected layer is not in prev state, so need to select by idx
			select(selected_idx)
			update_item_list_indicies(selected_idx)


## returns the name of the currently selected item
func get_curr_selected_name():
	var item_selected = get_selected_items()
	return get_item_text(item_selected[0])


## Selects item by name
## Returns if success or failure
func select_item_by_name(name):
	for i in range(get_item_count()):
		if get_item_text(i) == name:
			select(i)
			return true
	return false


## called when item is selected
func _on_item_selected(index):
	update_item_list_indicies(index)


## updates item list indices
## seperate from on_item_selected bc when using select() instead of manual,
## on_item_selected is not called
func update_item_list_indicies(index):
	# layer manager in Canvas
	var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager	

	# set current layer
	list_idx = index
	var lm_idx = (item_count - list_idx - 1)
	CanvasGlobals.current_layer_idx = lm_idx
	layer_manager.change_layer_to(lm_idx)


## called when add layer is pressed
func _on_add_layer_button_pressed():
	add_layer()

## add layer
func add_layer():
	# layer manager in Canvas
	var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager


	# add new layer
	add_layer_helper()
	var lm_idx = (item_count - list_idx - 1)
	layer_manager.add_layer_at(lm_idx)

	# set curr layer
	CanvasGlobals.current_layer_idx = lm_idx
	layer_manager.change_layer_to(lm_idx)

	# add to undo stack
	mouse_grid.strokeControl()

## housekeeping before adding the actual layer sprite; also used when opening a project file
func add_layer_helper():
	# add item above currently selected layer
	# set num layers
	var layer_num = CanvasGlobals.get_global_variable("num_layers")
	layer_num += 1
	CanvasGlobals.set_global_variable("num_layers", layer_num)

	# add item to list
	var last_idx = add_item("Layer " + str(layer_num), null, true)
	move_item(last_idx, list_idx)
	select(list_idx, true)




## called when delete layer is pressed
func _on_delete_layer_button_pressed():
	delete_layer()

func delete_layer():
	# layer manager in Canvas
	var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager

	if item_count == 1:
		# if only one layer left, don't remove
		return
	else:
		# delete layer
		var lm_idx = (item_count - list_idx - 1)
		layer_manager.delete_layer_at(lm_idx)

		# set curr layer
		if CanvasGlobals.current_layer_idx > 0:
			CanvasGlobals.current_layer_idx -= 1
		layer_manager.change_layer_to(CanvasGlobals.current_layer_idx)

		# update indices
		remove_item(list_idx)
		if list_idx == item_count:
			list_idx -= 1
		select(list_idx, true)

		# update textures
		layer_manager.update_all_layer_textures()

		# add to undo stack
		mouse_grid.strokeControl()
