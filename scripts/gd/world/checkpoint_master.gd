extends Node2D


# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# resets all checkpoints except for id
func checkpoint_reset(id : int): # have the id just be the actual checkpoint, checkpoint 2 is id 2 ranges (0,+infinity)
	for checkpoint in self.get_child_count():
		var current_checkpoint = self.get_child(checkpoint)
		if current_checkpoint.get_state() == true and checkpoint != (id - 1):
			current_checkpoint.set_state(false)
	animations()

func animations():
	for checkpoint in self.get_child_count():
		var current_checkpoint = self.get_child(checkpoint)
		current_checkpoint.get_child(1).play("active" if current_checkpoint.get_state() == true else "idle")
