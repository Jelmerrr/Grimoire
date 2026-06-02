extends Node2D

var currentStageMap: MapInstanceResource

func InitializeMapGenForStage() -> void:
	ClearCurrentStageMap()

func ClearCurrentStageMap() -> void:
	currentStageMap.maxRandomizedSize = Vector2(8,5) #This is base size, allowing for 8 encounters + 1 boss
	currentStageMap.mapData.clear()
