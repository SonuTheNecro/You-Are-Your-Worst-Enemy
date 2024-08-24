extends CanvasLayer
@onready var main = get_parent()


func _on_resume_pressed():
	MainMenuButtonSfx.main_menu_click()
	main.handle_pause()




func _on_main_menu_pressed():
	MainMenuButtonSfx.main_menu_click()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")




func _on_quit_pressed():
	MainMenuButtonSfx.main_menu_click()
	get_tree().quit()
