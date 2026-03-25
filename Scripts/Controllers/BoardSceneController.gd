extends Node2D

@onready var camera_2d: Camera2D = $"Control/SubViewportContainer/SubViewport/Player, Enemies & Attacks/Camera2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UtilsGlobalVariables.currentGameState = UtilsGlobalEnums.gameState.Planning
	SignalBus.Start_Planning_Phase.emit()
	AudioControllerScene.currentState = UtilsGlobalEnums.musicPlayerState.Stage1
	AudioControllerScene.playMusic()
	camera_2d.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
