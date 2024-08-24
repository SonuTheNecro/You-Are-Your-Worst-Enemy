extends CharacterBody2D
var player_pos = []
var player_animation = []
var player 
var array_pos : int = 0
var last_position : Vector2
var state : bool = true
var active : bool = false
var temp_active : bool = false
@export var wait_time : float
func _ready():
	self.global_position.x = -100
	self.global_position.y = -100
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.visible = false
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	$Spawn_Timer.wait_time = wait_time
func _physics_process(_delta):
	if active:
		last_position = self.global_position
		player = get_parent().get_node("player")
		if player != null and state == false:
			if player.get_death_status():
				state = true
		if player != null and $Spawn_Timer.is_stopped() and state:
			player_pos = player.get_player_position_array()
			player_animation = player.get_player_animation_array()
			if not player.get_death_status():
				self.global_position = player_pos[array_pos]
				$AnimatedSprite2D.play(player_animation[array_pos])
				$AnimatedSprite2D.flip_h = false if self.global_position.x - player.global_position.x < 0 else true
				array_pos += 1
func player_death(body):
	player_pos.clear()
	player_animation.clear()
	body.player_death()
	state = false
	array_pos = 0
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Spawn_Timer.start()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		self.player_death(body)
		

func _on_spawn_timer_timeout():
	$Area2D/CollisionShape2D.set_deferred("disabled", false)

func active_switch(value: bool):
	$AnimatedSprite2D.play("death" if value == false else "idle")
	if value:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$Spawn_Timer.start()
		$AnimatedSprite2D.visible = true
	self.active = value
	if not active:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
