extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "v." + FileGlobals.version_num
