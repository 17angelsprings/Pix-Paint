extends Node

@export var file_dialog: FileDialog

var image: Image

# for parsing a project file
var json_string
var json
var node_data
var array


# Open button is pressed so opening proces begins
func _on_pressed():
	print("open button is pressed")
	FileGlobals.load_image(file_dialog)


func _on_file_dialog_file_selected(path):
	
	if path.ends_with(".pix"):
		# open project file
		FileGlobals.open_project_file(path)
		json_string = FileGlobals.project_file.get_line()
		json = JSON.new()
		json.parse(json_string)
		node_data = json.get_data()
		json.parse(node_data["layer_0"])
		array = json.get_data()
		
		# Load the file and image
		image = Image.new()
		image.load_png_from_buffer(array)
		
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
		
		FileGlobals.set_global_variable("project_name", path.substr(0, path.length() - 4).get_slice("/", path.get_slice_count("/") - 1))
		
		FileGlobals.set_global_variable("image", image)
		FileGlobals.set_global_variable("file_path", path)
		FileGlobals.set_default_file_path(path)
		
	elif path.ends_with(".png"):
	
		# Load the file and image
		image = Image.new()
		image.load(path)
	
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
	
		FileGlobals.set_global_variable("project_name", path.substr(0, path.length() - 4).get_slice("/", path.get_slice_count("/") - 1))	
		
		FileGlobals.set_global_variable("image", image)
		FileGlobals.set_global_variable("file_path", path)
		FileGlobals.set_default_file_path(path)
	
	# Extract necessary variables (dimensions)
	CanvasGlobals.set_global_variable("canvas_size.x", image.get_width())
	CanvasGlobals.set_global_variable("canvas_size.y", image.get_height())
	
	# Hold texture in a global variable to transfer to workspace then go to it
	get_tree().change_scene_to_file("res://src/workspace/workspace.tscn")
