extends Node2D

var currentStageMap: MapInstanceResource = MapInstanceResource.new()

func InitializeMapGenForStage() -> void:
	ClearCurrentStageMap()

func ClearCurrentStageMap() -> void:
	currentStageMap.maxRandomizedSize = Vector2(8,5) #This is base size, allowing for 8 encounters + 1 boss with a heigth of 5
	currentStageMap.mapData.clear()

func PopulateMapData() -> void:
	var currentNodeAttempt: Vector2
	currentStageMap.mapData[currentNodeAttempt] = SetNodeData(currentNodeAttempt)

func SetNodeData(nodeLocation: Vector2) -> MapNodeResource:
	var result: MapNodeResource = MapNodeResource.new()
	result.mapPosition = nodeLocation
	return result
