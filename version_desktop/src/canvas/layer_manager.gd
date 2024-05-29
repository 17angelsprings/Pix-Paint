extends Node2D

## var to hold reference to current layer's sprite
var curr_layer_sprite: Sprite2D

## var to hold reference to curr layer's image
var curr_layer_image: Image


## Called when the node enters the scene tree for the first time.
## adds initial layer
func _ready():
	reset_canvas()


func reset_canvas():
	# set curr layer idx == 0
	CanvasGlobals.current_layer_idx = 0
	CanvasGlobals.num_layers = 0
	
	# clear img arrays
	CanvasGlobals.layer_images = []
	CanvasGlobals.prev_layer_images = []
	
	# delete all children
	print("LM children before reset deletion",get_child_count())
	for child in get_children():
		child.queue_free()
	
	# add layer
	add_layer_at(CanvasGlobals.current_layer_idx)
	# change layer
	change_layer_to(CanvasGlobals.current_layer_idx)


## changes the current layer sprite and image based on idx
func change_layer_to(child_idx:int):
	curr_layer_sprite = get_child(child_idx)
	curr_layer_image = CanvasGlobals.layer_images[child_idx]


## adds layer sprite to children and image to global array
## idx in children NOT layer item list
func add_layer_at(child_idx):
	# create a sprite
	var new_layer_sprite = Sprite2D.new();
	# set offset
	new_layer_sprite.offset = Vector2(CanvasGlobals.canvas_size.x/ 2, CanvasGlobals.canvas_size.y / 2)
	
	# add sprite as child
	if (get_child_count() == 0):
		add_child(new_layer_sprite)
	else:
		# get child at child_idx - 1
		var above_layer_sprite = get_child(child_idx-1)
		# add sibling so it is put at specific index
		above_layer_sprite.add_sibling(new_layer_sprite)
	
	# create image with format
	var new_layer_image = Image.create(CanvasGlobals.canvas_size.x, CanvasGlobals.canvas_size.y, false, Image.FORMAT_RGBA8)
	
	# insert to global array
	CanvasGlobals.layer_images.insert(child_idx, new_layer_image)
	CanvasGlobals.prev_layer_images.insert(child_idx, new_layer_image)
	print(CanvasGlobals.layer_images)

## deletes layer sprite and image
func delete_layer_at(child_idx):
	# delete sprite
	# remove as child
	var layer_sprite = get_child(child_idx)
	remove_child(layer_sprite)
	# free
	layer_sprite.queue_free()
	
	# delete image from global array
	CanvasGlobals.layer_images.remove_at(child_idx)
	CanvasGlobals.prev_layer_images.remove_at(child_idx)
	print(CanvasGlobals.layer_images)


## updates texture of sprite at idx of children NOT layer item list
func update_layer_texture_at(child_idx):
	# create texture from image in global array
	var new_texture = ImageTexture.create_from_image(CanvasGlobals.layer_images[child_idx])
	
	# set layer sprite texture
	var layer_sprite = get_child(child_idx)
	# print(layer_sprite.name)
	layer_sprite.set_texture(new_texture)
	
	# set global prev_layer_images[child_idx]
	CanvasGlobals.prev_layer_images[child_idx] = new_texture
