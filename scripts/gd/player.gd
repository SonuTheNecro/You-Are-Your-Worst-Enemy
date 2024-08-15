extends CharacterBody2D
const gravity : int = 140
const speed : int = 750
const acceleration : int = 50
const friction : int =  70
const jump_power : int = -2000

const max_jumps : int = 1
@onready var current_jumps : int = 0

func _physics_process(delta):
	var input_dir : Vector2 = input()
	if not is_on_floor():
		velocity.y += gravity
	else:
		velocity.y = 0
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(speed * input_dir, acceleration) #Accerlate
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)
	move_and_slide()
	
# Gets the direction based on your input
func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right") # Left = -1, Right = +1
	return input_dir
	
func play_animations():
	if abs(velocity.x) > 0.001:
		flip(velocity.x > 0)
		#$AnimatedSprite2D.flip_h = velocity.x > 0
# Flip the animations and hitboxes
func flip(value: bool):
	$AnimatedSprite2D.flip_h = value
func jump():
	if Input.is_action_just_pressed("jump"):
		if current_jumps < max_jumps:
			$AudioStreamPlayer2D.play()
			velocity.y = jump_power
			current_jumps += 1
		if is_on_floor():
			current_jumps = 0
