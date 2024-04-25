extends Node2D

# grid properties
# size of grid
var grid_size = Vector2(1000, 1000)
# size of grid cell
var cell_size = 10 
# mouse position
var coord = Vector2(-1, -1)
# canvas
var image
# make updates to canvas when true
var should_update_canvas = false

func _ready():
	set_process_input(true)
	createImage()
	updateTexture()
	$CanvasSprite.offset = Vector2(image.get_width() / 2, image.get_height() / 2)

# create canvas
func createImage():
	image = Image.create(1000, 1000, false, Image.FORMAT_RGBA8)

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
				pos.x = clamp(pos.x, 0, grid_size.x / cell_size - 1)
				pos.y = clamp(pos.y, 0, grid_size.y / cell_size - 1)
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
					for posx in range(event.position.x, event.position.x + ToolGlobals.pen_size):
						for posy in range(event.position.y, event.position.y + ToolGlobals.pen_size):
							image.set_pixel(posx, posy, Color(0, 0, 0, float(ToolGlobals.pen_opacity)/100.0))
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
			_draw_line(event.position - event.relative, event.position, Color(0, 0, 0, 0))
		else:
			_draw_line(event.position - event.relative, event.position, Color(0, 0, 0, 1))
		should_update_canvas = true

#draw on canvas following the mouse's position
func _draw_line(start: Vector2, end: Vector2, color: Color):
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
		for pos in getIntegerVectorLine(start, end):
			for posx in range(pos.x, pos.x + ToolGlobals.pen_size):
				for posy in range(pos.y, pos.y + ToolGlobals.pen_size):
					image.set_pixel(posx, posy, Color(0, 0, 0, float(ToolGlobals.pen_opacity)/100.0))
					
# check if mouse position is inside canvas
func is_mouse_inside_canvas(mouse_pos):
	return (mouse_pos.x >= 0 and mouse_pos.x < grid_size.x) and (mouse_pos.y >= 0 and mouse_pos.y < grid_size.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	if should_update_canvas:
		updateTexture()
		
#test
