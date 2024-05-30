extends ItemList

@onready var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager
var list_idx

## Sets the layer 0 as currenlty selected layer
func _ready():
	select(0, true);
	list_idx = 0


## Returns list of item list names
## ordered from topmost layer to bottom most (opposite layer_manager order)
func get_item_names():
	print("get_item_names() called")
	var item_names = []
	for i in range(get_item_count()):
		item_names.append(get_item_text(i))
	return item_names


## Sets names in item list
func set_item_names(name_arr):
	# print("set_item_names() called")
	clear()
	for name in name_arr:
		add_item(name)


## returns the name of the currently selected item
func get_curr_selected_name():
	# print("get_curr_selected_name() called")
	var item_selected = get_selected_items()
	return get_item_text(item_selected[0])


## Selects item by name
## Returns if success or failure
func select_item_by_name(name):
	# print("select_item_by_name() called")
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
	# set current layer
	list_idx = index
	var lm_idx = (item_count - list_idx - 1)
	CanvasGlobals.current_layer_idx = lm_idx
	layer_manager.change_layer_to(lm_idx)


## called when add layer is pressed
func _on_add_layer_button_pressed():
	# add item above currently selected layer
	# set num layers
	var layer_num = CanvasGlobals.get_global_variable("num_layers")
	layer_num += 1
	CanvasGlobals.set_global_variable("num_layers", layer_num)
	
	# add item to list
	var last_idx = add_item("Layer " + str(layer_num), null, true)
	move_item(last_idx, list_idx)
	select(list_idx, true)
	
	# add new layer
	var lm_idx = (item_count - list_idx - 1)
	layer_manager.add_layer_at(lm_idx)
	
	# set curr layer
	CanvasGlobals.current_layer_idx = lm_idx
	layer_manager.change_layer_to(lm_idx)


## called when delete layer is pressed
func _on_delete_layer_button_pressed():
	if item_count == 1:
		# if only one layer left, don't remove
		return
	else:
		# delete layer
		var lm_idx = (item_count - list_idx - 1)
		# print("lm_idx: ",lm_idx)
		layer_manager.delete_layer_at(lm_idx)
		
		# set curr layer
		if CanvasGlobals.current_layer_idx > 0:
			CanvasGlobals.current_layer_idx -= 1
		# print("curr layer idx: ", CanvasGlobals.current_layer_idx)
		layer_manager.change_layer_to(CanvasGlobals.current_layer_idx)
		
		# update indices
		remove_item(list_idx)
		if list_idx == item_count:
			list_idx -= 1
		select(list_idx, true)
