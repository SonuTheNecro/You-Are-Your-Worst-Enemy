extends Control
var go_to_level : int = 1

func _ready():
	$VBoxContainer/start_button.grab_focus()
func _on_start_button_pressed():
	MainMenuButtonSfx.main_menu_click()
	get_tree().change_scene_to_file("res://scenes/levels/world_1.tscn")
	
func _on_controls_button_pressed():
	MainMenuButtonSfx.main_menu_click()
	get_tree().change_scene_to_file("res://scenes/levels/controls.tscn")

func _on_quit_button_pressed():
	MainMenuButtonSfx.main_menu_click()
	get_tree().quit()
