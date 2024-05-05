extends Node

signal canvas_size_changed

var canvas_size = Vector2(100.0, 100.0):
	set = set_canvas_size # when canvas changes, set_canvas_size is called
var current_layer_idx

# Invisible image that protects opacity / blend properties
var invisible_image = Image.create(1000, 1000, false, Image.FORMAT_RGBA8)

func set_canvas_size(new_val):
	canvas_size_changed.emit() # emits a signal so other nodes can react to the change

func get_global_variable(var_name):
	match var_name:
		"current_layer_idx":
			return current_layer_idx
		"canvas_size.x":
			return canvas_size.x
		"canvas_size.y":
			return canvas_size.y
		_:
			print("Unknown global variable:", var_name)

func set_global_variable(var_name, value):
	print(value)
	match var_name:
		"current_layer_idx":
			current_layer_idx = value
		"canvas_size.x":
			canvas_size.x = value
		"canvas_size.y":
			canvas_size.y = value
		_:
			print("Unknown global variable:", var_name)

# reset invisible image
func reset_invisible_image():
	invisible_image = Image.create(1000, 1000, false, Image.FORMAT_RGBA8)

# is a pixel locked?
func invisible_image_green_light(posx, posy):
	return invisible_image.get_pixel(posx, posy) == Color(0,0,0,0)
	
# lock a pixel
func invisible_image_red_light(posx, posy):
	invisible_image.set_pixel(posx, posy, Color.TRANSPARENT)
