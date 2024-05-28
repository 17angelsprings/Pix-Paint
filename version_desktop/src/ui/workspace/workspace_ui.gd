extends Control

# if cursor is outside of canvas, revert back to default cursor
func _input(event):
	if event is InputEventMouseMotion:
		Input.set_custom_mouse_cursor(null)
