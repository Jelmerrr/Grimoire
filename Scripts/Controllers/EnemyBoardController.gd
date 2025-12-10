extends Node2D

const ENEMY_CHARACTER_SCENE = preload("uid://bkl1uw8420f1t")
const TRAINING_DUMMY = preload("uid://t8ncgrjjpm32")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Start_Planning_Phase.connect(SpawnEnemies)
	SignalBus.Stop_Combat.connect(ClearEnemies)
	SignalBus.Ask_EnemyPos.connect(AskPos)
	#SpawnEnemies()

func SpawnEnemies() -> void:
	InstanceEnemy(TRAINING_DUMMY, UtilsGlobalVariables.currentEnemyLevel, Vector2(150,-200))
	InstanceEnemy(TRAINING_DUMMY, UtilsGlobalVariables.currentEnemyLevel, Vector2(-150,-350))
	if UtilsGlobalVariables.currentEnemyLevel >= 9:
		InstanceEnemy(TRAINING_DUMMY, UtilsGlobalVariables.currentEnemyLevel, Vector2(-250,-100))

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

func GetEnemyPositions() -> Array[Vector2]:
	var result: Array[Vector2]
	for child in get_children():
		result.append(child.global_position)
	return result
