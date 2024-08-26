extends Node2D
@onready var pause_menu = $Pause_Menu
var paused : bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	pause_menu.hide()
	Engine.time_scale = 1
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		handle_pause()
		

func handle_pause():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused


func _on_button_pressed():
	MainMenuButtonSfx.main_menu_click()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
