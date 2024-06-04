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

## layer manager
@export var layer_manager: Node2D

## Canvas
var image: Image	

## Make updates to canvas when true
var should_update_canvas = false

## Mouse/Input Properties
## **********************************************************

## Mouse position
var coord = Vector2(-1, -1)

## Cursor images
var brush_cursor = preload("res://assets/brush.png")
var eraser_cursor = preload("res://assets/eraser.png")

## Flag to track whether a stroke is in progress
var is_stroke_in_progress = false

##
var allow_popup = false

## Undo/Redo Properties
## **********************************************************

## Reference to undo/redo script
@export var undo_redo_script: Node

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

## For exporting images

var exported_image

## Keep proportions bool
var keep_prop = true

## Dimensions to be exported
var canvas_size_x
var canvas_size_y
var new_dims

## New dim string
var new_dim = "New dimenstions (px): {x} x {y}"

## Current spinbox values
@onready var xSpinbox = $Export/VBoxContainer/xSpinBox
@onready var ySpinbox = $Export/VBoxContainer/ySpinBox

## Previous spinbox values
@onready var old_value_x
@onready var old_value_y

## Signals if x or y spinbox changed
var x_changed = false
var y_changed = false

var export_pressed = false

## FUNCTIONS
## ********************************************************************************

## Canvas Setup Functions
## **********************************************************

## Performs initial setup of canvas and related functions
## @params: none
## @return: none
func _ready():
	FileGlobals.set_global_variable("accessed_from_workspace", true)
	set_process_input(true)
	canvasInit()

	## Initialize canvas history
	strokeControl()

## Initializes canvas properties
## @params: none
## @return: none
func canvasInit():
	createImage()
	updateTexture()
	layer_manager.curr_layer_sprite.offset = Vector2(image.get_width() / 2, image.get_height() / 2)

## Creates canvas
## @params: none
## @return: none
func createImage():
	image = CanvasGlobals.get_global_variable("image")

## General Canvas Functions
## **********************************************************

## Updates new strokes after drawing to canvas
## @params: none
## @return: none
func updateTexture():
	layer_manager.update_layer_texture_at(CanvasGlobals.current_layer_idx)
	should_update_canvas = false

## Checks if canvas size should be updated
## @params: none
## @return: boolean value - denotes if canvas size should be updated
func shouldUpdateImageSize():
	var shouldUpdateImageSize = layer_manager.curr_layer_image.get_width() != CanvasGlobals.canvas_size.x or layer_manager.curr_layer_image.get_height() != CanvasGlobals.canvas_size.y
	return shouldUpdateImageSize

## Updates size of the canvas
## @params: none
## @return: none
func updateImageSize():
	# Before layers
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

	CanvasGlobals.set_global_variable("image", new_image)

	# with layers
	layer_manager.update_all_layer_image_sizes(CanvasGlobals.canvas_size.x, CanvasGlobals.canvas_size.y)
	layer_manager.change_layer_to(CanvasGlobals.current_layer_idx) # called to update layer_manager.curr_image

	grid_size.x = CanvasGlobals.canvas_size.x
	grid_size.y = CanvasGlobals.canvas_size.y

	canvasInit()

## Called every frame. 'delta' is the elapsed time since the previous frame.
## @params: delta
## @return: none
func _process(_delta):

	CanvasGlobals.prev_canvas_size.x = CanvasGlobals.canvas_size.x
	CanvasGlobals.prev_canvas_size.y = CanvasGlobals.canvas_size.y

	# undo button is pressed
	if CanvasGlobals.get_global_variable("undo_button_pressed"):
			undoStroke()
			CanvasGlobals.set_global_variable("undo_button_pressed", false)

	# redo button is pressed
	if CanvasGlobals.get_global_variable("redo_button_pressed"):
			redoStroke()
			CanvasGlobals.set_global_variable("redo_button_pressed", false)

	# save button is pressed
	if FileGlobals.get_global_variable("save_button_pressed"):
		saveImage()

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
	if ToolGlobals.get_global_variable("brush_eraser"):
		Input.set_custom_mouse_cursor(eraser_cursor, Input.CURSOR_ARROW, Vector2(4, 4))
	else:
		Input.set_custom_mouse_cursor(brush_cursor, Input.CURSOR_ARROW, Vector2(0, 0))
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			# new stroke
			CanvasGlobals.reset_invisible_image()
			# check that mouse is in canvas
			var mouse_pos = event.position
			if isMouseInsideCanvas(mouse_pos):
				# draw a pixel using draw_line with one position
				drawLine(event.position, event.position)
				is_stroke_in_progress = true
		else:
			# end of stroke
			is_stroke_in_progress = false
			updateTexture()
			strokeControl()

	elif event is InputEventMouseMotion:
		# check if a stroke is in progress
		if is_stroke_in_progress:
			# check mouse is in canvas
			var mouse_pos = event.position
			if isMouseInsideCanvas(mouse_pos):
				# draw line
				drawLine(event.position - event.relative, event.position)

	# CTRL + S = save work, CTRL + O = open work, CTRL + N = new canvas, CTRL + Z = undo, CTRL + Y = redo
	elif Input.is_key_pressed(KEY_CTRL):
		if Input.is_key_pressed(KEY_S):
			saveImage()
		elif Input.is_key_pressed(KEY_O):
			openImage()
		elif Input.is_key_pressed(KEY_N):
			CanvasGlobals.set_global_variable("image", Image.create(CanvasGlobals.get_global_variable("canvas_size.x"), CanvasGlobals.get_global_variable("canvas_size.y"), false, Image.FORMAT_RGBA8))
			image = CanvasGlobals.get_global_variable("image")
			get_tree().change_scene_to_file("res://src/ui/menu/new_canvas.tscn")
		elif Input.is_key_label_pressed(KEY_Z):
			undoStroke()
		elif Input.is_key_label_pressed(KEY_Y):
			redoStroke()

## Controls the addition of new strokes to canvas
## @params: none
## @return: none
func strokeControl():
	undo_redo_script.add_to_undo_stack()
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
func undoStroke():
	if undo_redo_script.undo():
		updateTexture()
		should_update_canvas = true

	if canvas_history.size() > 1:
		redo_stack.append(canvas_history.pop_back())
		var previous_state = canvas_history[canvas_history.size() - 1]
		image = previous_state.duplicate()
		updateTexture()
		should_update_canvas = true

## Redoes stroke
## @params: none
## @return: none
func redoStroke():
	if undo_redo_script.redo():
		updateTexture()
		should_update_canvas = true

	if redo_stack.size() > 0:
		canvas_history.append(redo_stack.pop_back())
		var next_state = canvas_history[canvas_history.size() - 1]
		image = next_state.duplicate()
		updateTexture()
		should_update_canvas = true

## Drawing Functions
## **********************************************************

## Converts the mouse path into an array of coordinates
## @params: start and end position of mouse
## @return: array of coordinates (tuples)
func getStrokePath(start_pos: Vector2, end_pos: Vector2) -> Array:
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
## @params: old color, new color
## @return: properties of new color
func blendColors(old_color: Color, new_color: Color) -> Color:
	var color = old_color.blend(new_color)
	return color


## Blend color with eraser opacity
## @params: current color, opacity
## @return: properties of new color
func blendedEraser(current_color: Color, opacity: float) -> Color:
	var blended_a = clamp(current_color.a - opacity/100.0, 0.0, 1.0)
	return Color(current_color.r, current_color.g, current_color.b, blended_a)

## Drawing for eraser
## @params: position of eraser
## @return: none
func drawEraser(posx, posy):
	var current_color = layer_manager.curr_layer_image.get_pixelv(Vector2(posx, posy))
	var blended_color = blendedEraser(current_color, ToolGlobals.eraser_opacity)
	layer_manager.curr_layer_image.set_pixel(posx, posy, blended_color)
	# lock pixel
	CanvasGlobals.invisible_image_red_light(posx, posy)

## Draw on canvas following the mouse's position
## @params: mouse's start and end position
## @return: none
func drawLine(start: Vector2, end: Vector2):
	if ToolGlobals.get_global_variable("brush_eraser"):
		for pos in getStrokePath(start, end):
			drawRectEraser(pos, ToolGlobals.eraser_size)
	else:
		for pos in getStrokePath(start, end):
			drawRectBrush(pos, ToolGlobals.brush_size)
	updateTexture()

## Draw rectangle for brush
## @params: position in path and size of brush
## @return: none
func drawRectBrush(pos: Vector2, size: int):
	var new_color = Color(ToolGlobals.brush_color.r, ToolGlobals.brush_color.g, ToolGlobals.brush_color.b, float(ToolGlobals.brush_opacity / 100.0))
	var rect = Rect2(pos - Vector2(size / 2, size / 2), Vector2(size, size))
	for x in range(int(rect.position.x), int(rect.position.x + rect.size.x)):
		for y in range(int(rect.position.y), int(rect.size.y + rect.position.y)):
			if x >= 0 and x < layer_manager.curr_layer_image.get_width() and y >= 0 and y < layer_manager.curr_layer_image.get_height():
				if CanvasGlobals.invisible_image_green_light(x, y):
					var current_color = layer_manager.curr_layer_image.get_pixel(x, y)
					if current_color.a > 0:
						var blended_color = blendColors(current_color, new_color)
						layer_manager.curr_layer_image.set_pixel(x, y, blended_color)
					else:
						layer_manager.curr_layer_image.set_pixel(x, y, new_color)
					CanvasGlobals.invisible_image_red_light(x, y)  # Lock the pixel after drawing

## Draw rectangle for eraser
## @params: position in path and size of eraser
## @return: none
func drawRectEraser(pos: Vector2, size: int):
	var rect = Rect2(pos - Vector2(size / 2, size / 2), Vector2(size, size))
	for x in range(int(rect.position.x), int(rect.position.x + rect.size.x)):
		for y in range(int(rect.position.y), int(rect.size.y + rect.position.y)):
			if x >= 0 and x < layer_manager.curr_layer_image.get_width() and y >= 0 and y < layer_manager.curr_layer_image.get_height():
				if CanvasGlobals.invisible_image_green_light(x, y):
					drawEraser(x, y)
					CanvasGlobals.invisible_image_red_light(x, y)  # Lock the pixel after erasing

## Checks if mouse position is inside canvas
## @params: mouse position
## @return: boolean value - indicates if mouse position is within canvas bounds
func isMouseInsideCanvas(mouse_pos):
	var within_bounds = (mouse_pos.x >= 0 and mouse_pos.x < CanvasGlobals.canvas_size.x) and (mouse_pos.y >= 0 and mouse_pos.y < CanvasGlobals.canvas_size.y)
	return within_bounds

## File I/O Functions
## **********************************************************

## Save Functions
## *********************************************

## Begins the process of saving your image
## @params: none
## @return: none
func saveImage():
	prepareImageForSaving()
	FileGlobals.set_global_variable("save_button_pressed", false)
	showSaveFileDialogDesktop()

## Prepares image for saving
## @params: none
## @return: none
func prepareImageForSaving():
	updateImageSize()
	image = CanvasGlobals.get_global_variable("image")
	
## Shows file dialog for saving your image (desktop version of program)
## @params: none
## @return: none
func showSaveFileDialogDesktop():
	$FileDialog_Save.set_current_path(FileGlobals.most_recent_file_path)

	if (FileGlobals.get_global_variable("project_name") != null):
		$FileDialog_Save.set_current_path(FileGlobals.get_global_variable("project_name"))
	else:
		$FileDialog_Save.set_current_path(FileGlobals.most_recent_file_path)
			
	if export_pressed == true:
		$FileDialog_Save.set_filters(PackedStringArray(["*.png ; PNG Images"]))
	else:
		$FileDialog_Save.set_filters(PackedStringArray(["*.pix ; PIX File", "*.png ; PNG Images"]))
	$FileDialog_Save.popup()
		
## Saves image once file path is selected (desktop version)
## @params: path
## @return: none
func _on_file_dialog_save_file_selected(path):

	image = CanvasGlobals.get_global_variable("image")
	FileGlobals.set_global_variable("project_name", path.substr(0, path.length() - 4).get_slice("/", path.get_slice_count("/") - 1))

	if path.ends_with(".pix"):
		saveAsPIXDesktop(path)

	elif path.ends_with(".png"):
		saveAsPNGDesktop(path)

## Saves the file as a PIX (desktop version)
## @params: path
## @return: none
func saveAsPIXDesktop(path):
	FileGlobals.save_image_pix_desktop(image, path)

## Saves the file as a PNG (desktop version)
## @params: path
## @return: none
func saveAsPNGDesktop(path):

	if export_pressed == true:
		FileGlobals.save_image_png_desktop(exported_image, path, CanvasGlobals.exported_layer_images)
		CanvasGlobals.exported_layer_images.clear()
		export_pressed = false
	else:
		FileGlobals.save_image_png_desktop(image, path, CanvasGlobals.layer_images)

## Opening Functions
## *********************************************

## Begins process of opening the image you want to from your device
## @params: none
## @return: none
func openImage():
	FileGlobals.show_open_image_file_dialog_desktop($FileDialog_Open)


## Loads image once file path is selected (desktop)
## @params: path
## @return: none
func _on_file_dialog_open_file_selected(path):

	FileGlobals.set_most_recent_file_path(path)

	if path.ends_with(".pix"):
		FileGlobals.open_format = 1
		get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

	elif path.ends_with(".png"):
		FileGlobals.open_format = 2
		get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")

## Export Functions
## *********************************************

## Begins process of exporting your image
## @params: none
## @return: none
func export():
	FileGlobals.set_global_variable("export_button_pressed", false)
	setupExportWindow()
	$Export.exclusive = true
	$Export.popup()

## Prepares values and text necessary to show on the Export popup window
## @params: none
## @return: none
func setupExportWindow():
	canvas_size_x = int(CanvasGlobals.canvas_size.x)
	canvas_size_y = int(CanvasGlobals.canvas_size.y)
	new_dims = Vector2(canvas_size_x, canvas_size_y)
	xSpinbox.set_value_no_signal(canvas_size_x)
	ySpinbox.set_value_no_signal(canvas_size_y)
	old_value_x = int(canvas_size_x)
	old_value_y = int(canvas_size_y)
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
	for i in range(CanvasGlobals.layer_images.size()):
		CanvasGlobals.exported_layer_images.append(CanvasGlobals.layer_images[i].duplicate())

	for layer in CanvasGlobals.exported_layer_images:
		layer.resize(xSpinbox.value, ySpinbox.value, 0)

	$Export.exclusive = false
	saveImage()
	$Export.hide()
