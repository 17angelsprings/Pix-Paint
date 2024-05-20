extends SubViewportContainer

@export var canvas_camera: Camera2D
var mouse_pos

## Used to detect mouse interaction for canvas camera
func _input(event):	
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:		# zoom in
			canvas_camera.zoom_io(canvas_camera.change_in_zoom, canvas_camera.offset)
			# offset to keep mouse in same place
			var zoom_term = (canvas_camera.zoom * canvas_camera.zoom)
			canvas_camera.offset += (Vector2(26,26) / zoom_term) * normal(mouse_pos)
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:			# zoom out
			if canvas_camera.zoom > Vector2(0.1,0.1):
				canvas_camera.zoom_io(-canvas_camera.change_in_zoom, canvas_camera.offset)
				# offset to keep mouse in same place
				var zoom_term = ((canvas_camera.zoom + Vector2(0.1,0.1)) * (canvas_camera.zoom + Vector2(0.1,0.1)))
				canvas_camera.offset -= (Vector2(26,26) / zoom_term) * normal(mouse_pos)
				print(canvas_camera.zoom)

## normalize vector (0,500) to (-1,1)
func normal(vec):
	vec -= Vector2(250,250)
	return vec/ Vector2(250,250)
