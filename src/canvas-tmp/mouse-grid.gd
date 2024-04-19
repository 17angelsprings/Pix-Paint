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
				print(coord) # instead of printing coord, we would implement the draw here some how

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
