extends ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	select(0, true);
	CanvasGlobals.set_global_variable("current_layer_idx", 0)
	pass # Replace with function body.

func _on_item_selected(index):
	# set current layer
	CanvasGlobals.set_global_variable("current_layer_idx", index)


func _on_add_layer_button_pressed():
	# add item above currently selected layer
	var last_idx = add_item("New Layer", null, true)
	var curr_idx = CanvasGlobals.current_layer_idx
	move_item(last_idx, curr_idx)
	select(curr_idx, true)
	CanvasGlobals.set_global_variable("current_layer_idx", curr_idx)


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
