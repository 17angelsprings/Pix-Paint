extends ItemList

@onready var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager
var list_idx

## Sets the layer 0 as currenlty selected layer
func _ready():
	select(0, true);
	CanvasGlobals.current_layer_idx = 0;
	list_idx = 0

func _on_item_selected(index):
	# set current layer
	list_idx = index
	CanvasGlobals.current_layer_idx = index
	
	# print(CanvasGlobals.current_layer_idx)


func _on_add_layer_button_pressed():
	# add item above currently selected layer
	var layer_num = CanvasGlobals.get_global_variable("num_layers")
	layer_num += 1
	CanvasGlobals.set_global_variable("num_layers", layer_num)
	
	var last_idx = add_item("Layer " + str(layer_num), null, true)
	move_item(last_idx, list_idx)
	select(list_idx, true)
	# print(CanvasGlobals.current_layer_idx)
	var lm_idx = (item_count - list_idx - 1)
	print("LM Children Idx: ", lm_idx)
	layer_manager.add_layer_at(lm_idx)
	
	# add new layer
	


func _on_delete_layer_button_pressed():
	if item_count == 1:
		# if only one layer left, don't remove
		return
	else:
		
		# delete layer
		
		# update indices
		if list_idx == item_count:
			list_idx -= 1
		select(list_idx, true)
