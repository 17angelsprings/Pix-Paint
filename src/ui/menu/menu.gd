extends Control

func _ready():
	#print("ready")
	var file_path = FileGlobals.get_default_file_path()
	if file_path == "0":
		var fd_dir = $HBoxContainer/VBoxContainer/OptionsMarginContainer/VBoxContainer/OpenButton/FileDialog.get_current_dir()
		var default_dir = fd_dir.erase(fd_dir.length() - 8, 8)
		FileGlobals.set_default_file_path(default_dir) # Changes default path
		FileGlobals.set_global_variable("file_path", default_dir) # Changes global file_path variable to new default path