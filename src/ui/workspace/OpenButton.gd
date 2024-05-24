extends Node

@export var file_dialog: FileDialog

var image: Image

# Open button is pressed so opening proces begins
func _on_pressed():
	FileGlobals.show_open_image_file_dialog_desktop(file_dialog)


func _on_file_dialog_file_selected(path):
	
	if path.ends_with(".pix"):
		FileGlobals.open_pix(path)
		
	elif path.ends_with(".png"):
		FileGlobals.open_png(path)
