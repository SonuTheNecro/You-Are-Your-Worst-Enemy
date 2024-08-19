extends Node2D


func _ready():
	$AnimatedSprite2D.play("open")



func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "open":
		get_parent().get_child(1).respawn()
		$AnimatedSprite2D.play("closed")
		get_parent().get_child(1).z_index = 1
