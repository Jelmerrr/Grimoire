extends Control

#Placeholder untill I make a proper Splash screen
func _ready() -> void:
	SceneTransitionControllerScene.transition("Fade_In")
	AudioControllerScene.currentState = UtilsGlobalEnums.musicPlayerState.MainMenu
	AudioControllerScene.playMusic()

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
	AudioControllerScene.fade_out(AudioControllerScene.music_player)
	SceneTransitionControllerScene.transition("Fade_Out")
	await SceneTransitionControllerScene.animation_player.animation_finished
	get_tree().quit()
