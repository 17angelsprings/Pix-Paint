extends Node2D

# grid properties
# size of grid cell
var cell_size = 1
# mouse position
var coord = Vector2(-1, -1)
# canvas
var image
# make updates to canvas when true
var should_update_canvas = false
# current pixel color
var pixel_color

func _ready():
	set_process_input(true)
	createImage()
	updateTexture()
	$CanvasSprite.offset = Vector2(image.get_width() / 2, image.get_height() / 2)

# create canvas
func createImage():
	#image = Image.create(1000, 1000, false, Image.FORMAT_RGBA8)
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
func print_intermediate_cells(start_pos, end_pos):
	var line_positions = getIntegerVectorLine(start_pos, end_pos)
		# print too make coords than necessary
		#for pos in line_positions:
			#print(pos)

# handle mouse input
func _input(event):
	if event is InputEventMouseButton:
		var mouse_pos = event.position
		if is_mouse_inside_canvas(mouse_pos):
			var pos = Vector2(int(event.position.x / cell_size), int(event.position.y / cell_size))
			if pos != coord:
				pos.x = clamp(pos.x, 0, CanvasGlobals.canvas_size.x / cell_size - 1)
				pos.y = clamp(pos.y, 0, CanvasGlobals.canvas_size.y / cell_size - 1)
				coord = pos
				print(coord)  # instead of printing coord, implement drawing here
				if ToolGlobals.get_global_variable("pen_eraser"):
					for posx in range(event.position.x, event.position.x + ToolGlobals.eraser_size):
						for posy in range(event.position.y, event.position.y + ToolGlobals.eraser_size):
							
							# grab current pixel color
							var current_color = image.get_pixelv(Vector2(posx, posy))
							# blend current color with eraser color based on opacity
							var blended_color = Color(
								current_color.r,
								current_color.g,
								current_color.b,
								clamp(current_color.a - float(ToolGlobals.eraser_opacity) / 100.0, 0.0, 1.0)
							)
							image.set_pixelv(Vector2(posx, posy), blended_color)
							
							#image.set_pixel(posx, posy, Color(0, 0, 0, 0))
				else:
					pixel_color = Color(ToolGlobals.pen_color.r, ToolGlobals.pen_color.g, ToolGlobals.pen_color.b, float(ToolGlobals.pen_opacity/100.0))
					for posx in range(event.position.x, event.position.x + ToolGlobals.pen_size):
						for posy in range(event.position.y, event.position.y + ToolGlobals.pen_size):
							image.set_pixel(posx, posy, pixel_color)
				should_update_canvas = true

	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		var mouse_pos = event.position
		if is_mouse_inside_canvas(mouse_pos):
			var end_pos = Vector2(int(mouse_pos.x / cell_size), int(mouse_pos.y / cell_size))
			if end_pos != coord:
				print(end_pos)
				print_intermediate_cells(coord, end_pos)
				coord = end_pos  # Update the current position after printing
		if ToolGlobals.get_global_variable("pen_eraser"):
			_draw_line(event.position - event.relative, event.position)
		else:
			_draw_line(event.position - event.relative, event.position)
		should_update_canvas = true
		
	# Press CTRL + S to save your work
	elif Input.is_key_pressed(KEY_CTRL):
		if Input.is_key_pressed(KEY_S):
			save_image()

#draw on canvas following the mouse's position
func _draw_line(start: Vector2, end: Vector2):
	if ToolGlobals.get_global_variable("pen_eraser"):
		for pos in getIntegerVectorLine(start, end):
			for posx in range(pos.x, pos.x + ToolGlobals.eraser_size):
				for posy in range(pos.y, pos.y + ToolGlobals.eraser_size):
					
					# grab current pixel color
					var current_color = image.get_pixelv(Vector2(posx, posy))
					# blend current color with eraser color based on opacity
					var blended_color = Color(
						current_color.r,
						current_color.g,
						current_color.b,
						clamp(current_color.a - float(ToolGlobals.eraser_opacity) / 100.0, 0.0, 1.0)
					)
					image.set_pixelv(Vector2(posx, posy), blended_color)
					
					#image.set_pixel(posx, posy, Color(0, 0, 0, 0))
	else:
		pixel_color = Color(ToolGlobals.pen_color.r, ToolGlobals.pen_color.g, ToolGlobals.pen_color.b, float(ToolGlobals.pen_opacity/100.0))
		for pos in getIntegerVectorLine(start, end):
			for posx in range(pos.x, pos.x + ToolGlobals.pen_size):
				for posy in range(pos.y, pos.y + ToolGlobals.pen_size):
					image.set_pixel(posx, posy, pixel_color)
					
# check if mouse position is inside canvas
func is_mouse_inside_canvas(mouse_pos):
	return (mouse_pos.x >= 0 and mouse_pos.x < CanvasGlobals.canvas_size.x) and (mouse_pos.y >= 0 and mouse_pos.y < CanvasGlobals.canvas_size.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	if FileGlobals.get_global_variable("save_button_pressed"):
		save_image()
	if should_update_canvas:
		updateTexture()
		
#test

# Save your work
func save_image():
	FileGlobals.set_global_variable("save_button_pressed", false)
	var file_path = FileGlobals.get_global_variable("file_path")
	print(file_path)
	# If this is your first time saving a file during current session
	if file_path == FileGlobals.get_default_file_path():
		$FileDialog.set_current_path(file_path)
		$FileDialog.set_filters(PackedStringArray(["*.png ; PNG Images"]))
		$FileDialog.popup()
		
	# If you have already saved the file before
	else:
		save_as_png(file_path)
	
# Once a file path is selected, it will save the image
func _on_file_dialog_file_selected(path):
	print(path)
	
	save_as_png(path)
		
	FileGlobals.set_global_variable("file_path", path)

#Saves the file as a PNG	
func save_as_png(path):
	# If selected file path doesn't already end in a .png (Creating a new file)
	if path.ends_with(".png") == false:
		image.save_png(path+".png")
		FileGlobals.set_default_file_path(path+".png")
		
	# If it does end in a .png (Overwriting an existing one essentially)
	else:
		image.save_png(path)
		FileGlobals.set_default_file_path(path)