extends Node2D

## variable for current layer, assumes initial is 0
## can make a global variable later
## will need to add signal so that the curr_layer_sprite changes when the curr layer changes
var curr_layer_idx: int = 0

## var to hold reference to current layer's sprite
var curr_layer_sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
## assumes start at curr_layer_ind
func _ready():
	change_layer_sprite_to(curr_layer_idx)

## changes the current layer sprite based on ind
func change_layer_sprite_to(idx:int):
	curr_layer_sprite = get_child(idx)
