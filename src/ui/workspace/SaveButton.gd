extends Node

@onready var fd_save = $save_dialog
const TEMP_PATH := "user://tmp"

# Called when the node enters the scene tree for the first time.
func _ready():
	fd_save.current_dir = "res://"

func _on_pressed():
	fd_save.visible = true
	

func _on_save_dialog_file_selected(path):
	DirAccess.make_dir_absolute(TEMP_PATH)
	if not TEMP_PATH:
		print("no path provided")
		return
		
	var drawing = get_node(TEMP_PATH)
	var texture = drawing.get_texture()
	var drawing_data = texture.get_data()
	var drawing_save = Image.new()
	var drawing_texture = ImageTexture.new()
	drawing_save.create_from_data(texture.get_width(), texture.get_height(), false, Image.FORMAT_RGBA8, drawing_data)
	drawing_texture.create_from_image(drawing)
	texture = drawing_texture
	var extension = path.get_extension().to_lower()
	
	#save as png
	if extension == "png":
		var error = drawing_save.save_png(path)
		if error != OK:
			print("error saving your drawing:", path)
		else:
			print("drawing saved successfully :", path)
			
	#save as tiff (filler block)
	elif extension == "tiff" or extension == "tif":
		var error = drawing_save.save_png(path)
		if error != OK:
			print("error saving your drawing:", path)
		else:
			print("drawing saved successfully :", path)
	
	#unsupported method
	else:
		print("unsupported file format:", path)
		
#this method hasn't been tested yet; especially for tiff
#need to test once canvas + drawing function is implemented
