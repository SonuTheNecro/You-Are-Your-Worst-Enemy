extends Camera2D


func _ready():
	set_camera_limit()
	
	
func set_camera_limit():
	match get_parent().get_level_id():
		0:
			self.limit_left = -63
			self.limit_bottom = 90
			self.limit_top = -90
			self.limit_right = 256
			$Panel.visible = false
			$Panel/Mili.visible = false
			$Panel/Minutes.visible = false
			$Panel/Seconds.visible = false
		1:
			self.limit_left = -63
			self.limit_top = -287
	
