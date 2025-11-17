extends Control

func _on_start_combat_button_pressed() -> void:
	SignalBus.Start_Combat.emit()
	UtilsGlobalVariables.currentGameState = UtilsGlobalEnums.gameState.Combat
