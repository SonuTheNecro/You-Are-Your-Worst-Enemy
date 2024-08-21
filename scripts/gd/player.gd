class_name Player
extends CharacterBody2D
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
const speed : int = 195
const acceleration : int = 9
const friction : int = 28
const jump_power : int = -365

var input_dir : Vector2
var coyote_check : bool = false
var wall_slide_check : bool = false
var jump_buffer_check : bool = false
var isSliding : bool = false
var isWallSliding: bool = false
var camera_position : Vector2
var last_checkpoint : Vector2 
var death : bool = false
@onready var collision_shape = $CollisionShape2D

var player_positions : Array[Vector2] = []
var player_animations: Array[String]  = []
func _ready():
	death = true
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if Input.is_action_just_pressed("respawn"):
		self.player_death()
	if death:
		return
	
	input_dir = input()
	if input_dir != Vector2.ZERO:
		velocity.x = lerp(velocity.x, input_dir.x * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
	jump(delta)
	wall_slide_check = self.is_on_wall() and not self.is_on_floor() and velocity.y > 0
	coyote_check = self.is_on_floor() if not Input.is_action_just_pressed("jump") else false
	self.move_and_slide()
	if coyote_check and not self.is_on_floor():
		$Coyote_Timer.start()
	slide()
	play_animations()
	player_positions.push_back(self.global_position)
	player_animations.push_back($AnimatedSprite2D.animation)
# Gets the direction based on your input
func input() -> Vector2:
	input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right") # Left = -1, Right = +1
	return input_dir
func play_animations():
	var state_to_play : String = ""
	if death:
		state_to_play = "death"
	elif isWallSliding:
		state_to_play = "wall_slide"
	elif self.velocity.y != 0 and not self.is_on_floor():
		state_to_play = "jump" if velocity.y < 0 else "fall"
	elif isSliding:
		state_to_play = "slide"
	elif abs(self.velocity.x) > 0.1 and self.is_on_floor():
		state_to_play = "walk"
	elif abs(self.velocity.x) < 0.1:
		state_to_play = "idle"
	$AnimatedSprite2D.play(state_to_play)
	if abs(velocity.x) > 0.001:
		flip(velocity.x < 0)
# Flip the animations and hitboxes
func flip(value: bool):
	if value != $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = value
#Handles Jumping
func jump(delta):
	handle_gravity(delta)
	if (jump_buffer_check or Input.is_action_just_pressed("jump")) and (is_on_floor() or $Coyote_Timer.time_left > 0.0001):
		self.velocity.y = jump_power
		disable_jumps_checks()
	elif (jump_buffer_check or Input.is_action_just_pressed("jump")) and is_on_wall():
		self.velocity.y = jump_power / 1.1
		self.velocity.x = lerp(self.velocity.x, -(input_dir.x * (speed * 5)), acceleration * delta)
		disable_jumps_checks()
	elif Input.is_action_just_pressed("jump") and not is_on_wall() and not is_on_floor():
		jump_buffer_check = true
		$Jump_Buffer_Timer.start()
	if Input.is_action_just_pressed("slide") and not is_on_floor():
		velocity.y = jump_power / 1.8 * -1
		coyote_check = false
	if Input.is_action_just_released("jump"):
		self.velocity.y = 0
# Handles Gravity
func handle_gravity(delta):
	if wall_slide_check:
		velocity.y += (gravity * 0.25) * delta
		isWallSliding = true
	elif not is_on_floor():  # Handles Gravity
		velocity.y += gravity * delta
		isWallSliding = false
	else:
		self.velocity.y = 0
		coyote_check = false
		isWallSliding = false
	if velocity.y > 600:
		velocity.y = 600
	if abs(velocity.x) > 300:
		velocity.x = 300 if input_dir.x == 1 else -300
func slide():
	var tile = get_parent().get_node("tiles/solid_tiles")
	#print(tile.get_cell_tile_data(tile.local_to_map(tile.to_local(Vector2(global_position.x, global_position.y - 8)))),velocity.x)
	if Input.is_action_just_pressed("slide") and is_on_floor():
		self.velocity.x = input_dir.x * (speed * 2.5)
		collision_shape.rotation_degrees = 90
		collision_shape.position.y = -2
		collision_shape.shape.set_radius(float(2))
		collision_shape.shape.set_height(float(8))
		isSliding = true
		
	if Input.is_action_just_released("slide") and is_on_floor() and tile.get_cell_tile_data(tile.local_to_map(tile.to_local(Vector2(global_position.x, global_position.y - 8)))) != null:
		collision_shape.rotation_degrees = 90
		collision_shape.position.y = -2
		collision_shape.shape.set_radius(float(2))
		collision_shape.shape.set_height(float(8))
		
	if  abs(self.velocity.x) < 0.01 and tile.get_cell_tile_data(tile.local_to_map(tile.to_local(Vector2(global_position.x, global_position.y - 8)))) == null:
		isSliding = false
		#abs(self.velocity).is_zero_approx()
		collision_shape.rotation_degrees = 0
		collision_shape.position.y = -5
		collision_shape.shape.set_radius(float(3))
		collision_shape.shape.set_height(float(10))
func player_death():
	if not death:
		death = true
		$AnimatedSprite2D.play("death")
		$CollisionShape2D.set_deferred("disabled", true)
		$Death_Timer.start()
func store_checkpoint(found_checkpoint: Area2D):
	last_checkpoint = found_checkpoint.global_position
func respawn():
	self.global_position = last_checkpoint
	$Camera2D.global_position = self.global_position
	$AnimatedSprite2D.visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	death = false
func jump_buffer_timer():
	jump_buffer_check = false
func disable_jumps_checks():
	jump_buffer_check = false
	coyote_check = false
	
func get_player_position_array():
	return player_positions
func get_player_animation_array():
	return player_animations
func get_death_status():
	return death
