extends Node2D

var currentStageMap: MapInstanceResource = MapInstanceResource.new()

func _ready() -> void:
	InitializeMapGenForStage()

func InitializeMapGenForStage() -> void:
	ClearCurrentStageMap()
	PopulateMapData()

func ClearCurrentStageMap() -> void:
	currentStageMap.maxRandomizedSize = Vector2(8,5) #This is base size, allowing for 8 encounters + 1 boss with a heigth of 5
	currentStageMap.mapData.clear()

func PopulateMapData() -> void:
	var currentNodeAttempt: Vector2 = Vector2(1,1)
	var populating: bool = true
	while populating:
		while currentNodeAttempt.y <= currentStageMap.maxRandomizedSize.y:
			currentStageMap.mapData[currentNodeAttempt] = SetNodeData(currentNodeAttempt)
			currentNodeAttempt.y += 1
		if currentNodeAttempt.x < currentStageMap.maxRandomizedSize.x:
			currentNodeAttempt.x += 1
			currentNodeAttempt.y = 1
			continue
		populating = false
		break
	print(currentStageMap.mapData)

func SetNodeData(nodeLocation: Vector2) -> MapNodeResource:
	var result: MapNodeResource = MapNodeResource.new()
	result.mapPosition = nodeLocation
	return result
