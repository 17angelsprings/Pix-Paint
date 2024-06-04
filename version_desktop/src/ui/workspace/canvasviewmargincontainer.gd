## CAVNAS_PANEL_CONTAINER.GD
## ********************************************************************************
## Script that deals with the visible canvas and viewport.
## ********************************************************************************

## ASSOCIATED SCENES
## ********************************************************************************
## canvas_panel_container.tcsn
## ********************************************************************************

## EXTENSIONS
## ********************************************************************************
extends MarginContainer
## ********************************************************************************

## SCRIPT-WIDE VARIABLES
## ********************************************************************************

## Canvas viewport
@export var canvas_viewport: Control

## Horizontal scroll bar
@export var hscrollbar: HScrollBar

## Vertical scroll bar
@export var vscrollbar: VScrollBar

## Horizontal margin container
@export var hmargin: MarginContainer

## Vertical margin container
@export var vmargin: MarginContainer

## Canvas camera node
var canvas_camera_node
## ********************************************************************************

## FUNCTIONS
## ********************************************************************************

## Connect to camera here
## Need to connect to zoom changed signal or show or hide scroll bars
## @params: none
## @return: none
func _ready():
	canvas_camera_node = canvas_viewport.canvas_camera
	if canvas_camera_node:
		print("canvas_camera_node connected to canvas view margin container")
		canvas_camera_node.connect("zoom_changed", _on_zoom_changed)
	## Assume start zoom is 1.0, so hide scroll bars
	hide_scrollbars()

## Triggered by camera signal
## Hides scroll bars if no zoom
## Updates scroll bar ranges based on zoom
## @params: new_zoom - vector of new zoom value
## @return: none
func _on_zoom_changed(new_zoom):
	if (new_zoom == Vector2(1,1) and canvas_camera_node.offset == Vector2(0,0)):
		hscrollbar.value = 0
		vscrollbar.value = 0
		hide_scrollbars()
	else:
		show_scrollbars()
	var new_start = - floor(100 + (new_zoom.x - 1) * 50)
	var new_end = - new_start
	update_scroll_bar_range(new_start, new_end)

## Hides the scrollbars
## Maintains positioning by making margins visible
## @params: none
## @return: none
func hide_scrollbars():
	hscrollbar.visible = false
	vscrollbar.visible = false
	hmargin.visible = true
	vmargin.visible = true

## Show the scrollbars
## Maintains positioning by making margins invisible
## @params: none
## @return: none
func show_scrollbars():
	hscrollbar.visible = true
	vscrollbar.visible = true
	hmargin.visible = false
	vmargin.visible = false

## Update the range of the scroll bars
## @params:
## start - new min value of scroll bars
## end - new max value of scroll bars
## @return: none
func update_scroll_bar_range(start,end):
	var vscrollbar_prev_value = vscrollbar.value
	var hscrollbar_prev_value = hscrollbar.value
	vscrollbar.min_value = start
	vscrollbar.max_value = end
	hscrollbar.min_value = start
	hscrollbar.max_value = end
	vscrollbar.value = vscrollbar_prev_value
	hscrollbar.value = hscrollbar_prev_value

## Modify camera offset.x based on scroll
## @params: value - new horizontal offset value
## @return: none
func _on_h_scroll_bar_value_changed(value):
	canvas_camera_node.offset.x = value 

## Modify camera offset.y based on scroll
## @params: value - new vertical offset value
## @return: none
func _on_v_scroll_bar_value_changed(value):
	canvas_camera_node.offset.y = value 

## Adjusts scroll bars in relation to keyboard inputs
## @params: event - user interaction
## @return: none
func _input(event):
	if hscrollbar.visible == true and vscrollbar.visible == true and event is InputEventKey and !Input.is_key_pressed(KEY_CTRL):
		## Shift + arrow key resets camera position on the axis of the key
		if Input.is_key_pressed(KEY_SHIFT):
			if Input.is_key_pressed(KEY_LEFT):
				hscrollbar.value = 0
			if Input.is_key_pressed(KEY_RIGHT):
				hscrollbar.value = 0
			if Input.is_key_pressed(KEY_UP):
				vscrollbar.value = 0
			if Input.is_key_pressed(KEY_DOWN):
				vscrollbar.value = 0
		## Arrows keys move camera position
		else:
			if Input.is_key_pressed(KEY_LEFT):
				hscrollbar.value -= 5
			if Input.is_key_pressed(KEY_RIGHT):
				hscrollbar.value += 5
			if Input.is_key_pressed(KEY_UP):
				vscrollbar.value -= 5
			if Input.is_key_pressed(KEY_DOWN):
				vscrollbar.value += 5

## Reset position (implicitly signals scroll bars to reset
## @params: none
## @return: none
func _on_reset_position_button_pressed():
	canvas_camera_node.camera_zoom = Vector2(1,1)
	canvas_camera_node.offset = Vector2(0,0)
	canvas_camera_node.camera_zoom = Vector2(1,1)
	canvas_camera_node.offset = Vector2(0,0)

