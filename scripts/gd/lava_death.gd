extends Area2D



func _physics_process(_delta):
	pass
	

func player_check(body: Node2D):
	if body.is_in_group("player"):
		body.death()
