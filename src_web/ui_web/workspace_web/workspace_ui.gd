extends Control

# if cursor is outside of canvas, revert back to default cursor
func _input(event):
	if event is InputEventMouseMotion:
		Input.set_custom_mouse_cursor(null)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
