extends Node2D

var image
var should_update_canvas = false
var drawing = false
var posList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	create_image()
	update_texture()
	$MyTexture.offset = Vector2(image.get_width() / 2, image.get_height() / 2)


func create_image():
	image = Image.create(1000, 1000, false, Image.FORMAT_RGBA8)	
	image.fill(Color.WHITE)
	
	
	
func update_texture():
	var texture = ImageTexture.create_from_image(image)
	$MyTexture.set_texture(texture)
	should_update_canvas = false	
	
	
func _input(event):
	if event is InputEventMouseButton:
		drawing = event.pressed
		#image.set_pixel(event.position.x, event.position.y, Color.BLACK)
		draw_rect(Rect2(event.position, Vector2(3.0, 3.0)), Color.BLACK)
		should_update_canvas = true
		
	if event is InputEventMouseMotion and drawing:
		_draw_line(event.position - event.relative, event.position, Color.BLACK)
		should_update_canvas = true

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


func _draw_line(start: Vector2, end: Vector2, color: Color):
	for pos in getIntegerVectorLine(start, end):
		image.set_pixelv(pos, color)
	
	

func _process(delta):	
	if should_update_canvas:
		update_texture()
