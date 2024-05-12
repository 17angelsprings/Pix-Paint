extends Control

@export var subviewcontainer: SubViewportContainer
@export var subviewport: SubViewport
@export var camerasubviewcontainer: SubViewportContainer
@export var camerasubviewport: SubViewport
@export var canvas_camera: Camera2D
@export var zoom_in_button: Button
@export var zoom_out_button: Button



func _ready():
	var canvas_global_script = get_node("/root/CanvasGlobals")
	if canvas_global_script:
		print("connected")
		canvas_global_script.connect("canvas_size_changed", _on_canvas_size_changed)
	update_canvas_size()
	
func _on_canvas_size_changed():
	print("Canvas Size Changed")
	update_canvas_size()
	
func update_canvas_size():
	# set viewport size to match canvas
	subviewport.size_2d_override = CanvasGlobals.canvas_size
	# camerasubviewport.size_2d_override = CanvasGlobals.canvas_size
	
	# set container size
	if CanvasGlobals.canvas_size.x == CanvasGlobals.canvas_size.y:
		subviewcontainer.size.x = 500
		subviewcontainer.size.y = 500
		# camerasubviewcontainer.size.x = 500
		# camerasubviewcontainer.size.y = 500
	# if width is bigger, x should be 600 and y should scale according to canvas size
	elif CanvasGlobals.canvas_size.x > CanvasGlobals.canvas_size.y:
		subviewcontainer.size.x = 500
		subviewcontainer.size.y = (500 * CanvasGlobals.canvas_size.y)/CanvasGlobals.canvas_size.x
		# camerasubviewcontainer.size.x = 500
		# camerasubviewcontainer.size.y = (500 * CanvasGlobals.canvas_size.y)/CanvasGlobals.canvas_size.x
	# if length is bigger, y should be 600 and x should scale according to canvas size
	else:
		subviewcontainer.size.y = 500
		subviewcontainer.size.x = (500 * CanvasGlobals.canvas_size.x)/CanvasGlobals.canvas_size.y
		# camerasubviewcontainer.size.y = 500
		# camerasubviewcontainer.size.x = (500 * CanvasGlobals.canvas_size.x)/CanvasGlobals.canvas_size.y
		
	# set container position, so that the canvas stays centered
	subviewcontainer.position.x = -(subviewcontainer.size.x/2)
	subviewcontainer.position.y = -(subviewcontainer.size.y/2)
	# camerasubviewcontainer.position.x = -(subviewcontainer.size.x/2)
	# camerasubviewcontainer.position.y = -(subviewcontainer.size.y/2)
	print("SubViewport Size: ", subviewport.size_2d_override)
	print("SubViewContainer Size: ", subviewcontainer.size)
