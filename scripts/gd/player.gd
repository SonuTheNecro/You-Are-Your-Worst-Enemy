class_name Player
extends CharacterBody2D
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
const speed : int = 195
const acceleration : int = 9
const friction : int = 28
const jump_power : int = -365

#const max_jumps : int = 1
#@onready var current_jumps : int = 0
var input_dir : Vector2
var checkpoint : int = 0
var coyote_check : bool = false
var wall_slide_check : bool = false
@onready var collision_shape = $CollisionShape2D
#static var player
#TODO: Turnaround delay

func _ready():
	#player = self
	pass

func _physics_process(delta):
	input_dir = input()
	if input_dir != Vector2.ZERO:
		velocity.x = lerp(velocity.x, input_dir.x * speed, acceleration * delta)
		#self.velocity = velocity.move_toward(speed * input_dir, acceleration) #Accerlate
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		#self.velocity = velocity.move_toward(Vector2.ZERO, friction)
	jump(delta)
	wall_slide_check = self.is_on_wall() and not self.is_on_floor() and velocity.y > 0
	coyote_check = self.is_on_floor() if not Input.is_action_just_pressed("jump") else false
	self.move_and_slide()
	if coyote_check and not self.is_on_floor():
		$Coyote_Timer.start()
	slide()
	play_animations()

# Gets the direction based on your input
func input() -> Vector2:
	input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right") # Left = -1, Right = +1
	return input_dir
	
func play_animations():
	if abs(velocity.x) > 0.001:
		flip(velocity.x < 0)
		#$AnimatedSprite2D.flip_h = velocity.x > 0

# Flip the animations and hitboxes
func flip(value: bool):
	if value != $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = value
#Handles Jumping
func jump(delta):
	handle_gravity(delta)
	if Input.is_action_just_pressed("jump") and (is_on_floor() or $Coyote_Timer.time_left > 0.0001):
		self.velocity.y = jump_power
		#self.velocity.y = lerp(self.velocity.y, float(jump_power), delta)
		#current_jumps += 1
	elif Input.is_action_just_pressed("jump") and is_on_wall():
		self.velocity.y = jump_power / 1.1
		self.velocity.x = lerp(self.velocity.x, -(input_dir.x * (speed * 5)), acceleration * delta)
		coyote_check = false
		#self.velocity.x = -input_dir.x * speed / 1.1 
	if Input.is_action_just_pressed("slide") and not is_on_floor():
		velocity.y = jump_power / 1.8 * -1
		coyote_check = false
	if Input.is_action_just_released("jump"):
		self.velocity.y = 0
# Handles Gravity
func handle_gravity(delta):
	if wall_slide_check:
		velocity.y += (gravity * 0.25) * delta
	elif not is_on_floor():  # Handles Gravity
		velocity.y += gravity * delta
	else:
		self.velocity.y = 0
		coyote_check = false
		
	if velocity.y > 600:
		velocity.y = 600
func slide():
	var tile = get_parent().get_node("Tiles/Grass")
	#print(tile.get_cell_tile_data(tile.local_to_map(tile.to_local(Vector2(global_position.x, global_position.y - 8)))),velocity.x)
	if Input.is_action_just_pressed("slide") and is_on_floor() and $Slide_Timer.is_stopped():
		self.velocity.x = input_dir.x * (speed * 2.5)
		collision_shape.rotation_degrees = 90
		collision_shape.position.y = -2
		collision_shape.shape.set_radius(float(2))
		collision_shape.shape.set_height(float(8))
		$Slide_Timer.start()
		
	if Input.is_action_just_released("slide") and is_on_floor() and tile.get_cell_tile_data(tile.local_to_map(tile.to_local(Vector2(global_position.x, global_position.y - 8)))) != null:
		collision_shape.rotation_degrees = 90
		collision_shape.position.y = -2
		collision_shape.shape.set_radius(float(2))
		collision_shape.shape.set_height(float(8))
		
	if abs(self.velocity).is_zero_approx() and tile.get_cell_tile_data(tile.local_to_map(tile.to_local(Vector2(global_position.x, global_position.y - 8)))) == null:
		collision_shape.rotation_degrees = 0
		collision_shape.position.y = -5
		collision_shape.shape.set_radius(float(3))
		collision_shape.shape.set_height(float(10))
		
func death():
	print("you have died!")
	pass

func respawn():
	pass
