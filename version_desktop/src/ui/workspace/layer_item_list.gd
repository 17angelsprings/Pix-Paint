extends ItemList

@onready var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager
var list_idx
var sprite_idx

# Called when the node enters the scene tree for the first time.
func _ready():
	select(0, true);
	CanvasGlobals.set_global_variable("current_layer_idx", 0)
	list_idx = 0
	sprite_idx = 0
	pass # Replace with function body.

func _on_item_selected(index):
	# set current layer
	list_idx = index
	
	sprite_idx = item_count - index - 1
	CanvasGlobals.set_global_variable("current_layer_idx", sprite_idx)
	layer_manager.curr_layer_idx = sprite_idx
	layer_manager.change_layer_sprite_to(sprite_idx)


func _on_add_layer_button_pressed():
	# add item above currently selected layer
	var layer_num = CanvasGlobals.get_global_variable("num_layers")
	layer_num += 1
	CanvasGlobals.set_global_variable("num_layers", layer_num)
	
	var last_idx = add_item("Layer " + str(layer_num), null, true)
	move_item(last_idx, list_idx)
	select(list_idx, true)
	
	# add new layer
	var sprite_old = layer_manager.get_child(0) 
	var sprite = sprite_old.duplicate()
	sprite.texture = null
	layer_manager.add_child(sprite)
	
	sprite_idx += 1
	layer_manager.move_child(sprite, sprite_idx)
	
	CanvasGlobals.set_global_variable("current_layer_idx", sprite_idx)
	layer_manager.curr_layer_idx = sprite_idx
	layer_manager.change_layer_sprite_to(sprite_idx)


func _on_delete_layer_button_pressed():
	if item_count == 1:
		# if only one layer left, don't remove
		return
	else:
		
		# delete layer
		remove_item(list_idx)
		var sprite_old = layer_manager.get_child(sprite_idx)
		layer_manager.remove_child(sprite_old)
		
		# update indices
		if list_idx == item_count:
			list_idx -= 1
		select(list_idx, true)
		if sprite_idx != 0:
			sprite_idx -= 1
			CanvasGlobals.set_global_variable("current_layer_idx", sprite_idx)
			layer_manager.curr_layer_idx = sprite_idx
			layer_manager.change_layer_sprite_to(sprite_idx)
