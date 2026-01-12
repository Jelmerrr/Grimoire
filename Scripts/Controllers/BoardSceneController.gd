extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UtilsGlobalVariables.currentGameState = UtilsGlobalEnums.gameState.Planning
	SignalBus.Start_Planning_Phase.emit()
	AudioControllerScene.currentState = UtilsGlobalEnums.musicPlayerState.Stage1
	AudioControllerScene.playMusic()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
