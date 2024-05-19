extends SubViewportContainer

@export var canvas_camera: Camera2D
var mouse_pos

## Used to detect mouse interaction for mouse
func _input(event):	
	if event is InputEventMouseMotion:
		mouse_pos = event.position

	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:		# zoom in
		# print(normal(mouse_pos))
		canvas_camera.zoom_io(canvas_camera.change_in_zoom, canvas_camera.offset)

	elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:			# zoom out
		#print(normal(mouse_pos))
		canvas_camera.zoom_io(-canvas_camera.change_in_zoom, canvas_camera.offset)

	elif event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
		print(canvas_camera.offset)

## normalize vector (0,500) to (-1,1)
func normal(vec):
	vec -= Vector2(250,250)
	return vec/ Vector2(250,250)
