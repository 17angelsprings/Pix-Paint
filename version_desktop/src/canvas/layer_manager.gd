## LAYER_MANAGER .GD
## ********************************************************************************
## Script for managing canvas layers functionality
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## workspace.tscn
## canvas.tscn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node2D
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## var to hold reference to current layer's sprite
var curr_layer_sprite: Sprite2D

## var to hold reference to curr layer's image
var curr_layer_image: Image

## FUNCTIONS
## ********************************************************************************

## Called when the node enters the scene tree for the first time.
## adds initial layer
## @params: none
## @return: none
func _ready():
	reset_canvas()


## Resets canvas related variables and creates intial layer 0
## @params: none
## @return: none
func reset_canvas():
	# set curr layer idx == 0
	CanvasGlobals.current_layer_idx = 0
	CanvasGlobals.num_layers = 0

	# clear img arrays
	CanvasGlobals.layer_images = []
	CanvasGlobals.prev_layer_images = []

	# delete all children
	for child in get_children():
		child.queue_free()

	# If a project is being opened from a project file	
	if FileGlobals.open_format == 1:
		var path = FileGlobals.get_most_recent_file_path()
		FileGlobals.open_pix_desktop(path)
		FileGlobals.open_format = 0

	# If a project is being opened from a png
	elif FileGlobals.open_format == 2:
		var path = FileGlobals.get_most_recent_file_path()
		FileGlobals.open_png_desktop(path)
		FileGlobals.open_format = 0
	# add layer
	else:
		add_layer_at(CanvasGlobals.current_layer_idx)

	update_all_layer_textures()

	# change layer
	change_layer_to(CanvasGlobals.current_layer_idx)


## Changes the current layer sprite and image based on idx
## @params: child_idx - index of child
## @return: none
func change_layer_to(child_idx:int):
	curr_layer_sprite = get_child(child_idx)
	curr_layer_image = CanvasGlobals.layer_images[child_idx]


## Adds layer sprite to children and image to global array
## idx in children NOT layer item list
## @params: child_idx - index of child
## @return: none
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

## Deletes layer sprite and image
## @params: child_idx - index of child
## @return: none
func delete_layer_at(child_idx):
	# delete sprite
	# remove as child
	var layer_sprite = get_child(child_idx)
	remove_child(layer_sprite)
	# free
	layer_sprite.queue_free()

	# delete image from global array
	CanvasGlobals.layer_images.remove_at(child_idx)


## Updates texture of sprite at idx of children NOT layer item list
## @params: child_idx - index of child
## @return: none
func update_layer_texture_at(child_idx):
	# create texture from image in global array
	var new_texture = ImageTexture.create_from_image(CanvasGlobals.layer_images[child_idx])

	# set layer sprite texture
	var layer_sprite = get_child(child_idx)
	layer_sprite.set_texture(new_texture)


## Updates texture of all sprites
## @params: none
## @return: none
func update_all_layer_textures():
	for i in range(CanvasGlobals.layer_images.size()):
		update_layer_texture_at(i)


## Resizes layer image @ child_idx to width x height
## @params: child_idx - index of child, width, height
## @return: none
func update_layer_image_size_at(child_idx, width, height):
	# create image with updated size
	var new_image: Image = Image.create(width, height, false, Image.FORMAT_RGBA8)

	# copy old image to new image
	var min_width
	var min_height

	if (new_image.get_width() < CanvasGlobals.layer_images[child_idx].get_width()):
		min_width = new_image.get_width()
	else:
		min_width = CanvasGlobals.layer_images[child_idx].get_width()
	if (new_image.get_height() < CanvasGlobals.layer_images[child_idx].get_height()):
		min_height = new_image.get_height()
	else:
		min_height = CanvasGlobals.layer_images[child_idx].get_height()
	for x in range(min_width):
		for y in range(min_height):
			new_image.set_pixel(x, y, CanvasGlobals.layer_images[child_idx].get_pixel(x, y))

	# set new offset
	var layer_sprite = get_child(child_idx)
	layer_sprite.offset = Vector2(CanvasGlobals.canvas_size.x/ 2, CanvasGlobals.canvas_size.y / 2)

	# replace old image with new image
	CanvasGlobals.layer_images[child_idx] = new_image


## Resizes all layer images to width x height
## @params: width, height
## @return: none
func update_all_layer_image_sizes(width, height):
	for i in range(CanvasGlobals.layer_images.size()):
		# resize image in image array
		update_layer_image_size_at(i, width, height)
	update_all_layer_textures()


## Loads new_image_array into layer images and updates sprites
## @params: new_img_arr - array of Images
## @return: none
func load_img_arr_into_layer_images(new_img_arr):
	CanvasGlobals.layer_images = new_img_arr
	update_all_layer_textures()


## Clears sprites and creates new ones matching new_img_arr
## @params: new_img_arr - array of Images
## @return: none
func restore_layer_images(new_img_arr):
	# remove all children
	while get_child_count() > 0:
		# remove as child
		var layer_sprite = get_child(0)
		remove_child(layer_sprite)
		# free
		layer_sprite.queue_free()

	# create new children matching new_img_arr count
	for i in range(new_img_arr.size()):
		# create a sprite
		var new_layer_sprite = Sprite2D.new();
		# set offset
		new_layer_sprite.offset = Vector2(CanvasGlobals.canvas_size.x/ 2, CanvasGlobals.canvas_size.y / 2)
		# add as child
		add_child(new_layer_sprite)

	# load imgs into layer_images
	load_img_arr_into_layer_images(new_img_arr)
