extends Area2D


func _on_body_entered(body):
	if body.is_in_group("player"):
		get_parent().get_node("enemy").active_switch(true)
		body.enemy_spawned = true
