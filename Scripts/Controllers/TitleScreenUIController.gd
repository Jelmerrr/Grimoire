extends Control

func _on_start_game_button_pressed() -> void:
	AudioControllerScene.fade_out(AudioControllerScene.music_player)
	UtilsSceneManager.switch_scene(UtilsSceneManager.BOARD_SCENE)


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_library_button_pressed() -> void:
	pass # Replace with function body.


func _on_achievements_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
