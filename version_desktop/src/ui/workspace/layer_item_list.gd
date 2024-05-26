extends ItemList

@onready var layer_manager = $/root/Workspace/WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/CanvasViewMarginContainer/HBoxContainer/VBoxContainer/CanvasViewport/CameraSubViewportContainer/CameraSubviewport/SubViewportContainer/SubViewport/Canvas/mouse_grid/layer_manager
var curr_idx

# Called when the node enters the scene tree for the first time.
func _ready():
	select(0, true);
	CanvasGlobals.set_global_variable("current_layer_idx", 0)
	pass # Replace with function body.

func _on_item_selected(index):
	# set current layer
	curr_idx = item_count - index - 1
	CanvasGlobals.set_global_variable("current_layer_idx", curr_idx)
	layer_manager.curr_layer_idx = curr_idx
	layer_manager.change_layer_sprite_to(curr_idx)


func _on_add_layer_button_pressed():
	# add item above currently selected layer
	var last_idx = add_item("New Layer", null, true)
	var curr_idx = CanvasGlobals.current_layer_idx
	move_item(last_idx, curr_idx)
	select(curr_idx, true)
	CanvasGlobals.set_global_variable("current_layer_idx", curr_idx)
	
	# add new layer
	var sprite_old = layer_manager.get_child(0)
	var sprite = sprite_old.duplicate()
	sprite.texture = null
	layer_manager.add_child(sprite)
	curr_idx = item_count - 1
	CanvasGlobals.set_global_variable("current_layer_idx", curr_idx)
	layer_manager.curr_layer_idx = curr_idx
	layer_manager.change_layer_sprite_to(curr_idx)


func _on_delete_layer_button_pressed():
	if item_count == 1:
		# if only one layer left, don't remove
		return
	else:
		# remove currently selected layer
		var curr_idx = CanvasGlobals.current_layer_idx
		remove_item(curr_idx)
		if curr_idx == item_count:
			# if last item removed, need to change curr idx and select that layer
			curr_idx = curr_idx - 1
			select(curr_idx, true)
		else:
			# else select layer in current idx
			select(curr_idx, true);
		CanvasGlobals.set_global_variable("current_layer_idx", curr_idx)
