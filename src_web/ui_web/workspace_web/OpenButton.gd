## (WEB VERSION)

extends Node

var image: Image

# Open button is pressed so opening proces begins
func _on_pressed():
	FileGlobals.show_open_image_file_dialog_web()
