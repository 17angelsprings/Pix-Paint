## MOUSE GRID .GD
## ********************************************************************************
## Handles setup and interaction of drawable canvas area including:
## - Drawing/erasing strokes
## - Resizing
## - Undo/redo
## - Saving/loading/exporting
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## canvas.tcsn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends Node2D
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Canvas Setup Properties
## **********************************************************

## Size of grid
var grid_size = Vector2(CanvasGlobals.canvas_size.x, CanvasGlobals.canvas_size.y)

## Size of grid cell
var cell_size = 10

## General Canvas Properties
## **********************************************************

## Canvas
var image: Image	

## Make updates to canvas when true
var should_update_canvas = false

## Mouse/Input Properties
## **********************************************************

## Mouse position
var coord = Vector2(-1, -1)

## Flag to track whether a stroke is in progress
var is_stroke_in_progress = false

##
var allow_popup = false

## Undo/Redo Properties
## **********************************************************

## Holds canvas history
var canvas_history = []

## Holds strokes to redo
var redo_stack = []

## Drawing Properties
## **********************************************************

## New pixel color
var new_color

## Current pixel color
var current_color

## Blended color
var blended_color

## File I/O Properties
## **********************************************************

## For parsing/saving a project file
var json_string
var json
var node_data
var array
var pix_dict

## For exporting images

var exported_image

# Keep proportions bool
var keep_prop = true

# Dimensions to be exported
var canvas_size_x
var canvas_size_y
var new_dims
# New dim string
var new_dim = "New dimenstions (px): {x} x {y}"

# Current spinbox values
@onready var xSpinbox = $Export/VBoxContainer/xSpinBox
@onready var ySpinbox = $Export/VBoxContainer/ySpinBox
# Previous spinbox values
@onready var old_value_x
@onready var old_value_y

# Signals if x or y spinbox changed
var x_changed = false
var y_changed = false

var export_pressed = false

## FUNCTIONS
## ********************************************************************************

## Canvas Setup Functions
## **********************************************************

## Initializes canvas
## @params: none
## @return: none
func canvasInit():
	createImage()
	updateTexture()
	$CanvasSprite.offset = Vector2(image.get_width() / 2, image.get_height() / 2)

## Performs setup for canvas
## @params: none
## @return: none
func _ready():
	FileGlobals.set_global_variable("accessed_from_workspace", true)
	set_process_input(true)
	canvasInit()
	# initialize canvas history
	stroke_control()

## Creates canvas
## @params: none
## @return: none
func createImage():
	image = FileGlobals.get_global_variable("image")

## General Canvas Functions
## **********************************************************

## Updates new strokes after drawing to canvas
## @params: none
## @return: none
func updateTexture():
	var texture = ImageTexture.create_from_image(image)
	$CanvasSprite.set_texture(texture)
	FileGlobals.set_global_variable("image", image)
	FileGlobals.set_global_variable("prev_image", image)
	should_update_canvas = false

## Checks if canvas size should be updated
## @params: none
## @return: 
func shouldUpdateImageSize():
	var shouldUpdateImageSize = image.get_width() != CanvasGlobals.canvas_size.x or image.get_height() != CanvasGlobals.canvas_size.y
	return shouldUpdateImageSize

## Updates size of the canvas
## @params: none
## @return: none
func updateImageSize():
	
	## Create resized image
	var new_image: Image = Image.create(CanvasGlobals.canvas_size.x, CanvasGlobals.canvas_size.y, false, Image.FORMAT_RGBA8)
		
	## Copy over current image to new image
	var min_width
	var min_height

	if (new_image.get_width() < image.get_width()):
		min_width = new_image.get_width()
	else:
		min_width = image.get_width()
	if (new_image.get_height() < image.get_height()):
		min_height = new_image.get_height()
	else:
		min_height = image.get_height()
	for x in range(min_width):
		for y in range(min_height):
			new_image.set_pixel(x, y, image.get_pixel(x, y))
				
	FileGlobals.set_global_variable("image", new_image)
	grid_size.x = CanvasGlobals.canvas_size.x
	grid_size.y = CanvasGlobals.canvas_size.y
	canvasInit()
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
## @params: delta
## @return: none
func _process(delta):
	
	CanvasGlobals.prev_canvas_size.x = CanvasGlobals.canvas_size.x
	CanvasGlobals.prev_canvas_size.y = CanvasGlobals.canvas_size.y
	
	# undo button is pressed
	if CanvasGlobals.get_global_variable("undo_button_pressed"):
			undo_stroke()
			CanvasGlobals.set_global_variable("undo_button_pressed", false)
			
	# redo button is pressed
	if CanvasGlobals.get_global_variable("redo_button_pressed"):
			redo_stroke()
			CanvasGlobals.set_global_variable("redo_button_pressed", false)
			
	# save button is pressed
	if FileGlobals.get_global_variable("save_button_pressed"):
		save_image()
	
	# export button is pressed
	if FileGlobals.get_global_variable("export_button_pressed"):
		export()
		
	if should_update_canvas:
		updateTexture()
	
	if shouldUpdateImageSize() == true:
		updateImageSize()

## Mouse/Input Functions
## **********************************************************

## Handles mouse input
## @params: event - an interaction or signal to the canvas
## @return: none
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			# new stroke
			CanvasGlobals.reset_invisible_image()
			# check that mouse is in canvas
			var mouse_pos = event.position
			if is_mouse_inside_canvas(mouse_pos):
				# draw a pixel using draw_line with one position
				_draw_line(event.position, event.position)
				is_stroke_in_progress = true
		else:
			# end of stroke
			is_stroke_in_progress = false
			updateTexture()
			stroke_control()
			
	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		# check if a stroke is in progress
		if is_stroke_in_progress:
			# check mouse is in canvas
			var mouse_pos = event.position
			if is_mouse_inside_canvas(mouse_pos):
				# draw line
				_draw_line(event.position - event.relative, event.position)
		
	# CTRL + S = save work, CTRL + O = open work, CTRL + N = new canvas, CTRL + Z = undo, CTRL + Y = redo
	elif Input.is_key_pressed(KEY_CTRL):
		if Input.is_key_pressed(KEY_S):
			save_image()
		elif Input.is_key_pressed(KEY_O):
			load_image()
		elif Input.is_key_pressed(KEY_N):
			FileGlobals.set_global_variable("image", Image.create(CanvasGlobals.get_global_variable("canvas_size.x"), CanvasGlobals.get_global_variable("canvas_size.y"), false, Image.FORMAT_RGBA8))
			image = FileGlobals.get_global_variable("image")
			get_tree().change_scene_to_file("res://src/ui/menu/new_canvas.tscn")
		elif Input.is_key_label_pressed(KEY_Z):
			undo_stroke()
		elif Input.is_key_label_pressed(KEY_Y):
			redo_stroke()
			


## Controls the addition of new strokes to canvas
## @params: none
## @return: none
func stroke_control():
	var current_state = image.duplicate()
	if canvas_history.size() == 0 or current_state != canvas_history[canvas_history.size() - 1]:
		canvas_history.append(current_state)
		# every time a new pixel is placed, redo stack is cleared
		redo_stack.clear()


## Undo/Redo Functions
## **********************************************************

## Undoes stroke
## @params: none
## @return: none
func undo_stroke():
	if canvas_history.size() > 1:
		redo_stack.append(canvas_history.pop_back())
		var previous_state = canvas_history[canvas_history.size() - 1]
		image = previous_state.duplicate()
		updateTexture()
		should_update_canvas = true
		
## Redoes stroke
## @params: none
## @return: none
func redo_stroke():
	if redo_stack.size() > 0:
		canvas_history.append(redo_stack.pop_back())
		var next_state = canvas_history[canvas_history.size() - 1]
		image = next_state.duplicate()
		updateTexture()
		should_update_canvas = true

## Drawing Functions
## **********************************************************

# copied directly over from drawing implementation
## @params: 
## @return: none
func getIntegerVectorLine(start_pos: Vector2, end_pos: Vector2) -> Array:
	var positions = []

	var x = int(start_pos.x)
	var y = int(start_pos.y)
	var end_x = int(end_pos.x)
	var end_y = int(end_pos.y)

	var dx = abs(end_x - x)
	var dy = -abs(end_y - y)

	var sx = 1  if x < end_x else -1
	var sy = 1  if y < end_y else -1

	var err = dx + dy

	while true:
		positions.append(Vector2(x, y))

		if x == end_x && y == end_y:
			break

		var e2 = 2 * err
		if e2 >= dy:
			err += dy
			x += sx
		if e2 <= dx:
			err += dx
			y += sy

	return positions


## Blends colors
## @params: 
## @return: properties of new color
func blend_colors(old_color: Color, new_color: Color) -> Color:
	var color = old_color.blend(new_color)
	return color


## Blend color with eraser opacity
## @params: 
## @return: properties of new color
func blended_eraser(current_color: Color, opacity: float) -> Color:
	var blended_a = clamp(current_color.a - opacity/100.0, 0.0, 1.0)
	return Color(current_color.r, current_color.g, current_color.b, blended_a)

## Drawing for eraser
## @params: 
## @return: none
func draw_eraser(posx, posy):
	var current_color = image.get_pixelv(Vector2(posx, posy))
	var blended_color = blended_eraser(current_color, ToolGlobals.eraser_opacity)
	image.set_pixel(posx, posy, blended_color)
	# lock pixel
	CanvasGlobals.invisible_image_red_light(posx, posy)


# draw on canvas following the mouse's position
## @params: 
## @return: none
func _draw_line(start: Vector2, end: Vector2):
	if ToolGlobals.get_global_variable("pen_eraser"):
		for pos in getIntegerVectorLine(start, end):
			_draw_rect_eraser(pos, ToolGlobals.eraser_size)
	else:
		for pos in getIntegerVectorLine(start, end):
			_draw_rect_pen(pos, ToolGlobals.pen_size)
	updateTexture()


# draw rectangle for pen
## @params: 
## @return: none
func _draw_rect_pen(pos: Vector2, size: int):
	var new_color = Color(ToolGlobals.pen_color.r, ToolGlobals.pen_color.g, ToolGlobals.pen_color.b, float(ToolGlobals.pen_opacity / 100.0))
	var rect = Rect2(pos - Vector2(size / 2, size / 2), Vector2(size, size))
	for x in range(int(rect.position.x), int(rect.position.x + rect.size.x)):
		for y in range(int(rect.position.y), int(rect.size.y + rect.position.y)):
			if x >= 0 and x < image.get_width() and y >= 0 and y < image.get_height():
				if CanvasGlobals.invisible_image_green_light(x, y):
					var current_color = image.get_pixel(x, y)
					if current_color.a > 0:
						var blended_color = blend_colors(current_color, new_color)
						image.set_pixel(x, y, blended_color)
					else:
						image.set_pixel(x, y, new_color)
					CanvasGlobals.invisible_image_red_light(x, y)  # Lock the pixel after drawing

# draw rectangle for eraser
## @params: 
## @return: none
func _draw_rect_eraser(pos: Vector2, size: int):
	var rect = Rect2(pos - Vector2(size / 2, size / 2), Vector2(size, size))
	for x in range(int(rect.position.x), int(rect.position.x + rect.size.x)):
		for y in range(int(rect.position.y), int(rect.size.y + rect.position.y)):
			if x >= 0 and x < image.get_width() and y >= 0 and y < image.get_height():
				if CanvasGlobals.invisible_image_green_light(x, y):
					draw_eraser(x, y)
					CanvasGlobals.invisible_image_red_light(x, y)  # Lock the pixel after erasing

## Checks if mouse position is inside canvas
## @params: 
## @return: boolen value - indicates if mouse position is within canvas bounds
func is_mouse_inside_canvas(mouse_pos):
	var within_bounds = (mouse_pos.x >= 0 and mouse_pos.x < CanvasGlobals.canvas_size.x) and (mouse_pos.y >= 0 and mouse_pos.y < CanvasGlobals.canvas_size.y)
	return within_bounds

## File I/O Functions
## **********************************************************

## Save Functions
## *********************************************

## Shows file dialog for saving your image
## @params: none
## @return: none
func save_image():
	updateImageSize()
	image = FileGlobals.get_global_variable("image")
	FileGlobals.set_global_variable("save_button_pressed", false)
	var file_path = FileGlobals.get_global_variable("file_path")
	$FileDialog_Save.set_current_path(file_path)

	if (FileGlobals.get_global_variable("project_name") != null):
		$FileDialog_Save.set_current_path(FileGlobals.get_global_variable("project_name"))
	else:
		$FileDialog_Save.set_current_path(file_path)
			
	if export_pressed == true:
		$FileDialog_Save.set_filters(PackedStringArray(["*.png ; PNG Images"]))
	else:
		$FileDialog_Save.set_filters(PackedStringArray(["*.pix ; PIX File", "*.png ; PNG Images"]))
	$FileDialog_Save.popup()
	
	
## Saves image once file path is selected
## @params: 
## @return: none
func _on_file_dialog_save_file_selected(path):
	#updateImageSize()
	image = FileGlobals.get_global_variable("image")
	FileGlobals.set_global_variable("project_name", path.substr(0, path.length() - 4).get_slice("/", path.get_slice_count("/") - 1))
	if path.ends_with(".pix"):
		# open project file
		FileGlobals.new_project_file(path)
		pix_dict = {
			"layer_0" : image.save_png_to_buffer()
		}
		json_string = JSON.stringify(pix_dict)
		FileGlobals.project_file.store_line(json_string)
		FileGlobals.project_file.close()
		
		FileGlobals.set_default_file_path(path)
		FileGlobals.set_global_variable("file_path", path)

	elif path.ends_with(".png"):
		save_as_png(path)
		
		FileGlobals.set_global_variable("file_path", path)

## Saves the file as a PNG
## @params: 
## @return: none
func save_as_png(path):

	# If selected file path doesn't already end in a .png (Creating a new file)
	if path.ends_with(".png") == false:
		if export_pressed == true:
			exported_image.save_png(path+".png")
			export_pressed = false
		else:
			image.save_png(path+".png")
		FileGlobals.set_default_file_path(path+".png")
		
	# If it does end in a .png (Overwriting an existing one essentially)
	else:
		if export_pressed == true:
			exported_image.save_png(path)
			export_pressed = false
		else:
			image.save_png(path)
		FileGlobals.set_default_file_path(path)

## Opening Functions
## *********************************************

## Shows file dialog for opening an image
## @params: none
## @return: none
func load_image():
	var file_path = FileGlobals.get_default_file_path()
	$FileDialog_Save.set_filters(PackedStringArray(["*.pix ; PIX Files", "*.png ; PNG Images"]))
	$FileDialog_Open.set_current_path(file_path)
	$FileDialog_Open.popup()

## Loads image once file path is selected
## @params: 
## @return: none
func _on_file_dialog_open_file_selected(path):
	
	if path.ends_with(".pix"):
		# open project file
		FileGlobals.open_project_file(path)
		json_string = FileGlobals.get_global_variable("project_file").get_line()
		json = JSON.new()
		json.parse(json_string)
		node_data = json.get_data()
		json.parse(node_data["layer_0"])
		array = json.get_data()
		
		# Load the file and image
		var image = Image.new()
		
		image.load_png_from_buffer(array)
		
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
		
		FileGlobals.set_global_variable("image", image)
		FileGlobals.set_global_variable("file_path", path)
		FileGlobals.set_default_file_path(path)
		CanvasGlobals.set_global_variable("canvas_size.x", image.get_width())
		CanvasGlobals.set_global_variable("canvas_size.y", image.get_height())
		
	elif path.ends_with(".png"):
	
		# Load the file and image
		var image = Image.new()
	
		image.load(path)
	
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
	
		FileGlobals.set_global_variable("image", image)
		FileGlobals.set_global_variable("file_path", path)
		FileGlobals.set_default_file_path(path)
		CanvasGlobals.set_global_variable("canvas_size.x", image.get_width())
		CanvasGlobals.set_global_variable("canvas_size.y", image.get_height())
	
	# Hold texture in a global variable to transfer to workspace then go to it
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")
	
## Export Functions
## *********************************************

## Shows popup window for exporting an image
## @params: none
## @return: none
func export():
	FileGlobals.set_global_variable("export_button_pressed", false)
	canvas_size_x = int(CanvasGlobals.canvas_size.x)
	canvas_size_y = int(CanvasGlobals.canvas_size.y)
	new_dims = Vector2(canvas_size_x, canvas_size_y)
	xSpinbox.set_value_no_signal(canvas_size_x)
	ySpinbox.set_value_no_signal(canvas_size_y)
	old_value_x = int(canvas_size_x)
	old_value_y = int(canvas_size_y)
	$Export.popup()
	var cur_dim = "Current dimensions (px): {x} x {y}"
	$Export/VBoxContainer/Current.text = cur_dim.format({"x": canvas_size_x, "y": canvas_size_y})
	$Export/VBoxContainer/New.text = new_dim.format({"x": xSpinbox.value, "y": ySpinbox.value})

## Hides export window
## @params: none
## @return: none
func _on_export_close_requested():
	$Export.hide()

## Activates or deactivates link proportions toggle
## @params: toggled_on - boolean value to indicate whether toggle is on or not
## @return: none
func _on_link_toggle_toggled(toggled_on):
	if toggled_on == false:
		keep_prop = false
	else:
		keep_prop = true


## Adjusts width of image to be exported
## @params: value - desired width value
## @return: none
func _on_x_spin_box_value_changed(value):
	xSpinbox.value = value

	if y_changed == false:
		x_changed = true
	# Keep proportions if applicable
		if keep_prop == true:
			ySpinbox.value += value - old_value_x
				
	
	$Export/VBoxContainer/New.text = new_dim.format({"x": xSpinbox.value, "y": ySpinbox.value})
	old_value_x = value
	x_changed = false

## Adjusts height of image to be exported
## @params: value - desired height value
## @return: none
func _on_y_spin_box_value_changed(value):
	ySpinbox.value = value
	
	if x_changed == false:
		y_changed = true
	# Keep proportions if applicable
		if keep_prop == true:
			xSpinbox.value += value - old_value_y
				
	$Export/VBoxContainer/New.text = new_dim.format({"x": xSpinbox.value, "y": ySpinbox.value})
	old_value_y = value
	y_changed = false


## Exports image as PNG file
## @params: none
## @return: none
func _on_png_pressed():
	export_pressed = true
	exported_image = image.duplicate()
	exported_image.resize(xSpinbox.value, ySpinbox.value, 0)
	save_image()
