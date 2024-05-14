extends MarginContainer

@export var canvas_viewport: Control
@export var hscrollbar: HScrollBar
@export var vscrollbar: VScrollBar
@export var hmargin: MarginContainer
@export var vmargin: MarginContainer

var canvas_camera

## connect to camera here
## need to connect to zoom changed signal or show or hide scroll bars
func _ready():
	var canvas_camera_node = canvas_viewport.canvas_camera
	if canvas_camera_node:
		print("canvas_camera_node connected to canvas view margin container")
		canvas_camera_node.connect("zoom_changed", _on_zoom_changed)
	# assume start zoom is 1.0, so hide scroll bars
	hide_scrollbars()

## triggered by camera signal
func _on_zoom_changed(new_zoom):
	print(new_zoom)
	if (new_zoom == Vector2(1,1)):
		hide_scrollbars()
	else:
		show_scrollbars()

## hides the scrollbars
## maintains positioning by making margins visible
func hide_scrollbars():
	hscrollbar.visible = false
	vscrollbar.visible = false
	hmargin.visible = true
	vmargin.visible = true

## show the scrollbars
## maintains positioning by making margins invisible
func show_scrollbars():
	hscrollbar.visible = true
	vscrollbar.visible = true
	hmargin.visible = false
	vmargin.visible = false
