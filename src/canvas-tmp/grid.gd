extends Node2D

# grid properties
	# container for grid
var canvas_size = Vector2(1000, 1000)
	# size of grid cell
var grid_spacing = 10
	# color of grid line
var grid_color = Color(0.1, 0.1, 0.1, 0.1) 

func _draw():
	draw_grid()

func draw_grid():
	# Draw horizontal grid lines
	for y in range(0, int(canvas_size.y) + 1, grid_spacing):
		draw_rect(Rect2(0, y - 1, canvas_size.x, 2), grid_color)

	# Draw vertical grid lines
	for x in range(0, int(canvas_size.x) + 1, grid_spacing):
		draw_rect(Rect2(x - 1, 0, 2, canvas_size.y), grid_color)
