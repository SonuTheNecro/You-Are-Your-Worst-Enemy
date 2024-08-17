extends CharacterBody2D
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
const speed : int = 200
const acceleration : int = 20
const friction : int =  25
const jump_power : int = -350

#const max_jumps : int = 1
#@onready var current_jumps : int = 0
var input_dir : Vector2
var checkpoint : int = 0
var coyote_check : bool = false
var wall_slide_check : bool = false



func _physics_process(delta):
	input_dir = input()
	wall_slide_check = self.is_on_wall() and not self.is_on_floor()
	handle_gravity(delta)
	if input_dir != Vector2.ZERO:
		velocity.x = lerp(velocity.x, input_dir.x * speed, acceleration * delta)
		#self.velocity = velocity.move_toward(speed * input_dir, acceleration) #Accerlate
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		#self.velocity = velocity.move_toward(Vector2.ZERO, friction)
	jump(delta)
	coyote_check = self.is_on_floor() if not Input.is_action_just_pressed("jump") else false
	self.move_and_slide()
	if coyote_check and not self.is_on_floor():
		$Coyote_Timer.start()

# Gets the direction based on your input
func input() -> Vector2:
	input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right") # Left = -1, Right = +1
	return input_dir
	
func play_animations():
	if abs(velocity.x) > 0.001:
		flip(velocity.x > 0)
		#$AnimatedSprite2D.flip_h = velocity.x > 0
# Flip the animations and hitboxes
func flip(value: bool):
	if value != $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = value
#Handles Jumping
func jump(delta):
	if Input.is_action_just_pressed("jump") and (is_on_floor() or $Coyote_Timer.time_left > 0.0001):
		self.velocity.y = jump_power
		#self.velocity.y = lerp(self.velocity.y, float(jump_power), delta)
		#current_jumps += 1
	elif Input.is_action_just_pressed("jump") and is_on_wall():
		self.velocity.y = jump_power / 1.1
		self.velocity.x = lerp(self.velocity.x, -(input_dir.x * (speed * 5)), acceleration * delta)
		#self.velocity.x = -input_dir.x * speed / 1.1 
# Handles Gravity
func handle_gravity(delta):
	if not is_on_floor():  # Handles Gravity
		velocity.y += gravity * delta
	else:
		self.velocity.y = 0
		coyote_check = false
		wall_slide_check = false
func death():
	print("you have died!")
	pass

func respawn():
	pass
