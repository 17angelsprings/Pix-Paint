extends SubViewport

@export var canvas_camera: Camera2D
var mouse_pos

## Used to detect mouse interaction for mouse
func _input(event):	
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		canvas_camera.offset += (mouse_pos - Vector2(50,50)/Vector2(canvas_camera.zoom))
		canvas_camera.zoom_io(canvas_camera.change_in_zoom, canvas_camera.offset)
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		canvas_camera.offset -= (mouse_pos - Vector2(50,50)/Vector2(canvas_camera.zoom))
		canvas_camera.zoom_io(-canvas_camera.change_in_zoom, canvas_camera.offset)
