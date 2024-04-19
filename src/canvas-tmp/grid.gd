extends Node2D

# grid properties
var grid_size = Vector2(10, 10)  # size of grid cell
var grid_color = Color(0.5, 0.5, 0.5, 0.5)  # grid line color

func _draw():
	var canvas_size = get_viewport_rect().size
	var num_horizontal_lines = int(canvas_size.y / grid_size.y)
	var num_vertical_lines = int(canvas_size.x / grid_size.x)
	
	# horizontal grid lines
	for i in range(num_horizontal_lines):
		var y = i * grid_size.y
		draw_line(Vector2(0, y), Vector2(canvas_size.x, y), grid_color)
	
	# vertical grid lines
	for i in range(num_vertical_lines):
		var x = i * grid_size.x
		draw_line(Vector2(x, 0), Vector2(x, canvas_size.y), grid_color)
