extends Node2D

const ENEMY_CHARACTER_SCENE = preload("uid://bkl1uw8420f1t")
const TRAINING_DUMMY = preload("uid://t8ncgrjjpm32")
const TRAINING_DUMMY_2 = preload("uid://c8ob4odotuy8q")
const TRAINING_DUMMY_3 = preload("uid://ch77rk1lmoii2")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Start_Planning_Phase.connect(SpawnEnemies)
	SignalBus.Stop_Combat.connect(ClearEnemies)
	SignalBus.Ask_EnemyPos.connect(AskPos)

func SpawnEnemies() -> void:
	GenerateEncounter()
	InstanceEnemy(TRAINING_DUMMY_3, UtilsGlobalVariables.currentEnemyLevel, Vector2(150,-100))
	InstanceEnemy(TRAINING_DUMMY_2, UtilsGlobalVariables.currentEnemyLevel, Vector2(-150,-150))
	if UtilsGlobalVariables.currentEnemyLevel >= 9:
		InstanceEnemy(TRAINING_DUMMY, UtilsGlobalVariables.currentEnemyLevel, Vector2(-50,-200))

func InstanceEnemy(enemyResource:BaseEnemyResource, level: int, spawnPos: Vector2) -> void:
	var instance = ENEMY_CHARACTER_SCENE.instantiate()
	instance.global_position = spawnPos
	instance.level = level
	instance.enemyResource = enemyResource
	add_child.call_deferred(instance)

func ClearEnemies() -> void:
	for child in get_children():
		child.queue_free()

func AskPos() -> void:
	UtilsGlobalVariables.enemyPositions = GetEnemyPositions()

func GetEncounterBaseValue() -> int:
	var encounterValue = UtilsGlobalVariables.currentEncountersValue
	var baseValueResult :int = 8 + (6 * (encounterValue-1))
	return baseValueResult

func GenerateEncounter() -> void:
	var encounterValue = GetEncounterBaseValue()
	var encounterValueUnspent = encounterValue
	var GeneratedEncounter: Array[BaseEnemyResource]
	var allowedSpawns: Array[BaseEnemyResource] = []
	while encounterValueUnspent > 0:
		allowedSpawns = GetEnemyReferences(encounterValueUnspent)
		if !allowedSpawns.is_empty():
			var rngResult = UtilsRngHandler.rng.randi_range(0, (allowedSpawns.size()-1))
			GeneratedEncounter.append(allowedSpawns[rngResult])
			encounterValueUnspent -= (allowedSpawns[rngResult].difficultyValue + (allowedSpawns[rngResult].difficultyValueIncreasePerLevel * (UtilsGlobalVariables.currentEnemyLevel - 1)))
		else:
			break
	for item in GeneratedEncounter:
		print(item.enemyName)

func GetEnemyReferences(maxValue: int) -> Array[BaseEnemyResource]:
	var EnemyRefs: Array[BaseEnemyResource] = []
	for file in DirAccess.get_files_at("res://Resources/Enemy/Enemy Resources/Regular/"):
		var loadedResource: BaseEnemyResource = ResourceLoader.load("res://Resources/Enemy/Enemy Resources/Regular/"+file)
		var resourceEncounterValue: int = loadedResource.difficultyValue + (loadedResource.difficultyValueIncreasePerLevel * (UtilsGlobalVariables.currentEnemyLevel - 1))
		if resourceEncounterValue <= maxValue:
			EnemyRefs.append(ResourceLoader.load("res://Resources/Enemy/Enemy Resources/Regular/"+file))
	return EnemyRefs

func GetEnemyPositions() -> Array[Vector2]:
	var result: Array[Vector2]
	for child in get_children():
		if child.alive:
			result.append(child.global_position)
	return result
