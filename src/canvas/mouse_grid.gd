extends Node2D

# grid properties
# size of grid
var grid_size = Vector2(CanvasGlobals.get_global_variable("canvas_size.x"), CanvasGlobals.get_global_variable("canvas_size.y"))
# size of grid cell
var cell_size = 10
# mouse position
var coord = Vector2(-1, -1)
# canvas
var image
# make updates to canvas when true
var should_update_canvas = false
# new pixel color
var new_color
# current pixel color
var current_color
# blended color
var blended_color

# for parsing/saving a project file
var json_string
var json
var node_data
var array
var pix_dict


func _ready():
	set_process_input(true)
	createImage()
	updateTexture()
	$CanvasSprite.offset = Vector2(image.get_width() / 2, image.get_height() / 2)

# create canvas
func createImage():
	image = FileGlobals.get_global_variable("image")

#update new strokes after drawing to canvas	
func updateTexture():
	var texture = ImageTexture.create_from_image(image)
	$CanvasSprite.set_texture(texture)
	should_update_canvas = false
	
# copied directly over from drawing implementation
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

# print all cells between start and end positions
#func print_intermediate_cells(start_pos, end_pos):
	#var line_positions = getIntegerVectorLine(start_pos, end_pos)
		# print too make coords than necessary
		#for pos in line_positions:
			#print(pos)

# handle mouse input
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		# new stroke
		CanvasGlobals.reset_invisible_image()
		# check that mouse is in canvas
		var mouse_pos = event.position
		if is_mouse_inside_canvas(mouse_pos):
			# draw a pixel using draw_line with one position
			_draw_line(event.position, event.position)
			should_update_canvas = true

	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		# check mouse is in canvas
		var mouse_pos = event.position
		if is_mouse_inside_canvas(mouse_pos):
			# draw line
			_draw_line(event.position - event.relative, event.position)
			should_update_canvas = true
		
	# Press CTRL + S to save your work, CTRL + O to open another work, or CTRL + N to open a new canvas
	elif Input.is_key_pressed(KEY_CTRL):
		if Input.is_key_pressed(KEY_S):
			save_image()
		elif Input.is_key_pressed(KEY_O):
			load_image()
		elif Input.is_key_pressed(KEY_N):
			FileGlobals.set_global_variable("image", Image.create(CanvasGlobals.get_global_variable("canvas_size.x"), CanvasGlobals.get_global_variable("canvas_size.y"), false, Image.FORMAT_RGBA8))
			image = FileGlobals.get_global_variable("image")
			get_tree().change_scene_to_file("res://src/ui/menu/new_canvas.tscn")

#blend colors
func blend_colors(old_color: Color, new_color: Color) -> Color:
	var color = old_color.blend(new_color)
	return color

# drawing for pen
func draw_pen(posx, posy):
	new_color = Color(ToolGlobals.pen_color.r, ToolGlobals.pen_color.g, ToolGlobals.pen_color.b, float(ToolGlobals.pen_opacity/100.0))
	current_color = image.get_pixel(posx, posy)
	if current_color.a > 0:
		blended_color = blend_colors(current_color, new_color)
		image.set_pixel(posx, posy, blended_color)
	else:
		image.set_pixel(posx, posy, new_color)
	# lock pixel
	CanvasGlobals.invisible_image_red_light(posx, posy)

#blend color with eraser opacity
func blended_eraser(current_color: Color, opacity: float) -> Color:
	var blended_a = clamp(current_color.a - opacity/100.0, 0.0, 1.0)
	return Color(current_color.r, current_color.g, current_color.b, blended_a)

# drawing for eraser
func draw_eraser(posx, posy):
	var current_color = image.get_pixelv(Vector2(posx, posy))
	var blended_color = blended_eraser(current_color, ToolGlobals.eraser_opacity)
	image.set_pixel(posx, posy, blended_color)
	# lock pixel
	CanvasGlobals.invisible_image_red_light(posx, posy)
	

#draw on canvas following the mouse's position
func _draw_line(start: Vector2, end: Vector2):
	if ToolGlobals.get_global_variable("pen_eraser"):
		for pos in getIntegerVectorLine(start, end):
			for posx in range(pos.x, pos.x + ToolGlobals.eraser_size):
				for posy in range(pos.y, pos.y + ToolGlobals.eraser_size):
					# is pixel locked?
					if CanvasGlobals.invisible_image_green_light(posx, posy):
						draw_eraser(posx, posy)
	else:
		for pos in getIntegerVectorLine(start, end):
			for posx in range(pos.x, pos.x + ToolGlobals.pen_size):
				for posy in range(pos.y, pos.y + ToolGlobals.pen_size):
					# is pixel locked?
					if CanvasGlobals.invisible_image_green_light(posx, posy):
						draw_pen(posx, posy)

# check if mouse position is inside canvas
func is_mouse_inside_canvas(mouse_pos):
	return (mouse_pos.x >= 0 and mouse_pos.x < CanvasGlobals.canvas_size.x) and (mouse_pos.y >= 0 and mouse_pos.y < CanvasGlobals.canvas_size.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	if FileGlobals.get_global_variable("save_button_pressed"):
		save_image()
	if FileGlobals.get_global_variable("export_button_pressed"):
		export()
	if should_update_canvas:
		updateTexture()

# SAVE FUNCTIONALITY **************************************************8

# Save your work
func save_image():
	FileGlobals.set_global_variable("save_button_pressed", false)
	var file_path = FileGlobals.get_global_variable("file_path")
	$FileDialog_Save.set_current_path(file_path)
	# If this is your first time saving a file during current session
	if file_path == FileGlobals.get_default_file_path():
		if (FileGlobals.get_global_variable("project_name") != null):
			$FileDialog_Save.set_current_path(FileGlobals.get_global_variable("project_name"))
		else:
			$FileDialog_Save.set_current_path(file_path)
			
		if export_pressed == true:
			$FileDialog_Save.set_filters(PackedStringArray(["*.png ; PNG Images"]))
		else:
			$FileDialog_Save.set_filters(PackedStringArray(["*.pix ; PIX File", "*.png ; PNG Images"]))
		$FileDialog_Save.popup()
		
	# If you have already saved the file before
	else:
		if file_path.ends_with(".pix") and export_pressed == false:
			FileGlobals.new_project_file(file_path)
			pix_dict = {
				"layer_0" : image.save_png_to_buffer()
			}
			json_string = JSON.stringify(pix_dict)
			FileGlobals.project_file.store_line(json_string)
			FileGlobals.project_file.close()
			
			FileGlobals.set_default_file_path(file_path)
		else:
			if file_path.ends_with(".pix") == true:
				file_path[-2] = "n"
				file_path[-1] = "g"
			save_as_png(file_path)
	
	
# Once a file path is selected, it will save the image
func _on_file_dialog_save_file_selected(path):
	print(path)
	FileGlobals.set_global_variable("project_name", path.substr(0, path.length() - 4).get_slice("/", path.get_slice_count("/") - 1))
	print("project name:", FileGlobals.get_global_variable("project_name"))
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

#Saves the file as a PNG	
func save_as_png(path):
	# If selected file path doesn't already end in a .png (Creating a new file)
	if path.ends_with(".png") == false:
		if export_pressed == true:
			exported_image.save_png(path+".png")
		else:
			image.save_png(path+".png")
		FileGlobals.set_default_file_path(path+".png")
		
	# If it does end in a .png (Overwriting an existing one essentially)
	else:
		if export_pressed == true:
			exported_image.save_png(path+".png")
		else:
			image.save_png(path)
		FileGlobals.set_default_file_path(path)

func load_image():
	var file_path = FileGlobals.get_default_file_path()
	$FileDialog_Save.set_filters(PackedStringArray(["*.pix ; PIX Files", "*.png ; PNG Images"]))
	if file_path == "0":
		var fd_dir = $FileDialog_Open.get_current_dir()
		var default_dir = fd_dir.erase(fd_dir.length() - 9, 9)
		FileGlobals.set_default_file_path(default_dir)
		print(default_dir)
		$FileDialog_Open.set_current_path(default_dir)
		$FileDialog_Open.popup()
	else:
		$FileDialog_Open.set_current_path(file_path)
		$FileDialog_Open.popup()


func _on_file_dialog_open_file_selected(path):
	print(path)
	
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
		
	elif path.ends_with(".png"):
	
		# Load the file and image
		var image = Image.new()
	
		image.load(path)
	
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
	
		FileGlobals.set_global_variable("image", image)
		FileGlobals.set_global_variable("file_path", path)
		FileGlobals.set_default_file_path(path)
	
	# Extract necessary variables (dimensions)
	
	
	# Hold texture in a global variable to transfer to workspace then go to it
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")
	
# EXPORT FUNCTIONALITY *********************************************

# Variables
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

# *************************************************
	

# EXPORT WINDOW
func export():
	FileGlobals.set_global_variable("export_button_pressed", false)
	canvas_size_x = int(CanvasGlobals.get_global_variable("canvas_size.x"))
	canvas_size_y = int(CanvasGlobals.get_global_variable("canvas_size.y"))
	new_dims = Vector2(canvas_size_x, canvas_size_y)
	xSpinbox.set_value_no_signal(canvas_size_x)
	ySpinbox.set_value_no_signal(canvas_size_y)
	old_value_x = int(canvas_size_x)
	old_value_y = int(canvas_size_y)
	$Export.popup()
	var cur_dim = "Current dimensions (px): {x} x {y}"
	$Export/VBoxContainer/Current.text = cur_dim.format({"x": canvas_size_x, "y": canvas_size_y})
	$Export/VBoxContainer/New.text = new_dim.format({"x": xSpinbox.value, "y": ySpinbox.value})

# Hides window
func _on_export_close_requested():
	$Export.hide()
#*******************************************

# EXPORT OPTION FUNCTIONALITY

# LINK TOGGLE
func _on_link_toggle_toggled(toggled_on):
	if toggled_on == false:
		keep_prop = false
	else:
		keep_prop = true
	print(keep_prop)


# SPINBOX VALS
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


# EXPORT PNG BUTTON PRESSED
var export_pressed = false
func _on_png_pressed():
	export_pressed = true
	exported_image = image
	exported_image.resize(xSpinbox.value, ySpinbox.value, 0)
	save_image()
	exported_image.resize(canvas_size_x, canvas_size_y)
	export_pressed = false
