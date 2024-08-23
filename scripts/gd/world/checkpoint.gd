class_name Checkpoint
extends Area2D
@onready var state : bool = false
@export var id : int
func _on_body_entered(body):
	#print_information()
	if body.is_in_group("player"):
		body.store_checkpoint(self)
		self.state = true
		get_parent().checkpoint_reset(id)


func get_state():
	return self.state

func set_state(new_state : bool):
	self.state = new_state

func print_information():
	print(self.state, " ", self.id, " ",$AnimatedSprite2D.animation)
