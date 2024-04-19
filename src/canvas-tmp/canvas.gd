extends Node2D

# canvas properties
# size of canvas
var canvas_size = Vector2(1000, 1000)
# size of pixel
var pixel_size = 1

# canvas base
func _draw():
	# alternating squares
	for y in range(int(canvas_size.y / pixel_size)):
		for x in range(int(canvas_size.x / pixel_size)):
			if (x + y) % 2 == 0:
				draw_rect(Rect2(x * pixel_size, y * pixel_size, pixel_size, pixel_size), Color(0.9, 0.9, 0.9))
			else:
				draw_rect(Rect2(x * pixel_size, y * pixel_size, pixel_size, pixel_size), Color(0.8, 0.8, 0.8))
