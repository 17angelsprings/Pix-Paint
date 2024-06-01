extends ItemList

@onready var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager
var list_idx = 0

## Sets the layer 0 as currenlty selected layer
func _ready():
	select(0, true);
	list_idx = 0

func _on_item_selected(index):
	select_item(index)
	
func select_item(index):
	# set current layer
	list_idx = index
	var lm_idx = (item_count - list_idx - 1)
	CanvasGlobals.current_layer_idx = lm_idx
	layer_manager.change_layer_to(lm_idx)
	
	# print(CanvasGlobals.current_layer_idx)


func _on_add_layer_button_pressed():
	add_layer()

func add_layer():
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
	# print(CanvasGlobals.current_layer_idx)


func _on_delete_layer_button_pressed():
	delete_layer()

func delete_layer():
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
		
		
