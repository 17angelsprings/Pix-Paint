extends Node2D

# grid properties
# size of grid
var grid_size = Vector2(1000, 1000)
# size of grid cell
var cell_size = 10 
# mouse position
var coord = Vector2(-1, -1)

func _ready():
	set_process_input(true)
	
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

	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		var mouse_pos = event.position
		if is_mouse_inside_canvas(mouse_pos):
			var end_pos = Vector2(int(mouse_pos.x / cell_size), int(mouse_pos.y / cell_size))
			if end_pos != coord:
				print(end_pos)
				print_intermediate_cells(coord, end_pos)
				coord = end_pos  # Update the current position after printing

# grid
func _draw():
	# horizontal grid lines
	for y in range(0, int(grid_size.y), cell_size):
		draw_line(Vector2(0, y), Vector2(grid_size.x, y), Color(0.0, 0.0, 1.0), 1.0) # current grid is set to blue for personal visibility
	
	# vertical grid lines
	for x in range(0, int(grid_size.x), cell_size):
		draw_line(Vector2(x, 0), Vector2(x, grid_size.y), Color(0.0, 0.0, 1.0), 1.0) # current grid is set to blue for personal visibility

# check if mouse position is inside canvas
func is_mouse_inside_canvas(mouse_pos):
	return (mouse_pos.x >= 0 and mouse_pos.x < grid_size.x) and (mouse_pos.y >= 0 and mouse_pos.y < grid_size.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
