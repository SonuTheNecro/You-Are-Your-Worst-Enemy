extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("Camera2D").get_node("Panel").stop_timer()
		body.get_parent().get_node("enemy").active_switch(false)
