extends Camera2D
# zoom in node path WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/ZoomMarginContainer/HBoxContainer/ZoomInButton
# zoom out node path WorkspaceUI/WorkspaceContainer/HBoxContainer/CanvasPanelContainer/VBoxContainer/ZoomMarginContainer/HBoxContainer/ZoomOutButton

@export var canvas_viewport: Control
@export var change_in_zoom: float

# Connect to zoom buttons in workspace
func _ready():
	var zoom_in_button_node = canvas_viewport.zoom_in_button
	var zoom_out_button_node = canvas_viewport.zoom_out_button
	if zoom_in_button_node:
		print("zoom in button connected to camera")
		zoom_in_button_node.connect("pressed", _on_zoom_in_button_pressed)
	if zoom_out_button_node:
		print("zoom out button connected to camera")
		zoom_out_button_node.connect("pressed", _on_zoom_out_button_pressed)
		
func _on_zoom_in_button_pressed():
	zoom_in(change_in_zoom, Vector2(0,0))
	
func _on_zoom_out_button_pressed():
	zoom_out(change_in_zoom, Vector2(0,0))
	
func zoom_in(amount, focus):
	zoom += Vector2(amount,amount)
	offset = focus
	
func zoom_out(amount, focus):
	zoom -= Vector2(amount,amount)
	offset = focus
