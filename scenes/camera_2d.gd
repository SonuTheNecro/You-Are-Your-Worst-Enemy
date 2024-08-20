extends Camera2D


func _ready():
	set_camera_limit()
	
	
func set_camera_limit():
	self.limit_left = -63
	self.limit_top = -287
