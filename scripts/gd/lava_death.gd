extends Area2D



func _physics_process(_delta):
	#position.x = 
	pass
	

func player_check(body: Node2D):
	if body.is_in_group("player"):
		body.player_death()
