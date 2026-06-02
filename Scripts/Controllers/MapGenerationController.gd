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
		var emptyNodesInRow: int = UtilsRngHandler.rng.randi_range(0, currentStageMap.maxRandomizedSize.y - 2)
		var isNodeEmptyForStage: Array[bool] = PopulateEmptyNodeData(emptyNodesInRow)
		while currentNodeAttempt.y <= currentStageMap.maxRandomizedSize.y:
			var preliminaryNodeType: UtilsGlobalEnums.nodeTypes
			if isNodeEmptyForStage[currentNodeAttempt.y - 1]:
				preliminaryNodeType = UtilsGlobalEnums.nodeTypes.Empty
			else:
				preliminaryNodeType = UtilsGlobalEnums.nodeTypes.Encounter
			currentStageMap.mapData[currentNodeAttempt] = SetNodeData(currentNodeAttempt, preliminaryNodeType)
			currentNodeAttempt.y += 1
		if currentNodeAttempt.x < currentStageMap.maxRandomizedSize.x:
			currentNodeAttempt.x += 1
			currentNodeAttempt.y = 1
			continue
		populating = false
		break
	for item in currentStageMap.mapData:
		print(currentStageMap.mapData[item].mapPosition)
		print(UtilsGlobalEnums.nodeTypes.keys()[currentStageMap.mapData[item].nodeType])

func SetNodeData(nodeLocation: Vector2, nodeType: UtilsGlobalEnums.nodeTypes) -> MapNodeResource:
	var result: MapNodeResource = MapNodeResource.new()
	result.nodeType = nodeType
	result.mapPosition = nodeLocation
	return result

func PopulateEmptyNodeData(emptyNodesInRow: int) -> Array[bool]:
	var result: Array[bool]
	var tempCycleValue: int = 0
	while tempCycleValue < emptyNodesInRow:
		result.append(true)
		tempCycleValue += 1
	while result.size() < currentStageMap.maxRandomizedSize.y:
		result.append(false)
	UtilsRngHandler.shuffleArray(result)
	return result
