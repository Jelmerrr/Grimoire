extends Node2D

const ENEMY_CHARACTER_SCENE = preload("uid://bkl1uw8420f1t")
const TRAINING_DUMMY = preload("uid://t8ncgrjjpm32")
const TRAINING_DUMMY_2 = preload("uid://c8ob4odotuy8q")
const TRAINING_DUMMY_3 = preload("uid://ch77rk1lmoii2")

var enemySocialDistancing: int = 25 #Minimal distance on each axis an enemy must have

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Start_Planning_Phase.connect(SpawnEnemies)
	SignalBus.Stop_Combat.connect(ClearEnemies)
	SignalBus.Ask_EnemyPos.connect(AskPos)

func SpawnEnemies() -> void:
	GenerateEncounter()

func InstanceEnemy(enemyResource:BaseEnemyResource, additionalDifficulty: int, spawnPos: Vector2) -> void:
	var instance = ENEMY_CHARACTER_SCENE.instantiate()
	instance.global_position = spawnPos
	instance.additionalHealthFromDifficulty = additionalDifficulty * enemyResource.additionalDifficultyHpScaling
	instance.enemyResource = enemyResource
	add_child.call_deferred(instance)

func ClearEnemies() -> void:
	for child in get_children():
		child.queue_free()

func AskPos() -> void:
	UtilsGlobalVariables.enemyPositions = GetEnemyPositions()

func GenerateEncounter() -> void:
	#Generates the encounter as a list of enemy resources
	var encounterValue = GetEncounterBaseValue()
	var encounterValueUnspent = encounterValue
	var generatedEncounter: Array[BaseEnemyResource]
	var generatedEncounterLevels: Array[int]
	var allowedSpawns: Array[BaseEnemyResource] = []
	while encounterValueUnspent > 0:
		#Grabs random enemy references based on difficulty value left in the pool
		allowedSpawns = GetEnemyReferences(encounterValueUnspent)
		if !allowedSpawns.is_empty():
			var rngResult = UtilsRngHandler.rng.randi_range(0, (allowedSpawns.size()-1))
			generatedEncounter.append(allowedSpawns[rngResult])
			generatedEncounterLevels.append(0)
			encounterValueUnspent -= (allowedSpawns[rngResult].difficultyValue)
		else:
			while encounterValueUnspent > 0:
				#Leftover difficulty pool is randomly distributed among existing enemies to increase hp
				var rngResult = UtilsRngHandler.rng.randi_range(0, (generatedEncounter.size()-1))
				generatedEncounterLevels[rngResult] += 1
				encounterValueUnspent -= 1
			break
	#Generate positions and instance enemies
	var enemyGenPositions: Array[Vector2] = [Vector2(0, 0)]
	var enemyIndex: int = 0
	for enemy in generatedEncounter:
		var resultVector: Vector2
		var hasPosition: bool = false
		var posAttempts: int = 0
		while !hasPosition:
			var rngResultX = UtilsRngHandler.rng.randi_range(-250, 250)
			var rngResultY = UtilsRngHandler.rng.randi_range(-100, -200)
			#If randomly generated position is outside of social distancing of each existing enemy it is valid
			for pos in enemyGenPositions:
				if !rngResultX in range(pos.x-enemySocialDistancing, pos.x+enemySocialDistancing)\
				 && !rngResultY in range(pos.y-enemySocialDistancing, pos.y+enemySocialDistancing):
					resultVector = Vector2(rngResultX,rngResultY)
					enemyGenPositions.append(resultVector)
					hasPosition = true
					break
			#If after 5 attempts no position has been found, use default positioning for performance, can lead to issues but fine for now
			posAttempts += 1
			if posAttempts >= 5:
				printerr("Warning: No suitable enemy spawn position has been found. Are you spawning too many enemies?")
				resultVector = Vector2(0, -150)
				enemyGenPositions.append(resultVector)
				hasPosition = true
				break
		
		#Properly adjust difficulty value and finalize instance spawning
		var diffValue: int = generatedEncounterLevels[enemyIndex]
		enemyIndex += 1
		InstanceEnemy(enemy, diffValue, resultVector)

func GetEncounterBaseValue() -> int:
	#Calculates overall encounter difficulty value based on current stage
	var encounterValue = UtilsGlobalVariables.currentEncountersValue
	var baseValueResult :int = 8 + (6 * (encounterValue-1)) #TODO: Make this a logarithmic graph in the future
	return baseValueResult

func GetEnemyReferences(maxValue: int) -> Array[BaseEnemyResource]:
	#Grabs every available enemy able to be spawned and compares it to the unspent difficulty value left available
	var EnemyRefs: Array[BaseEnemyResource] = []
	#TODO: Adjust this system to be functional with different enemy types such as elites and bosses
	for file in DirAccess.get_files_at("res://Resources/Enemy/Enemy Resources/Regular/"):
		var loadedResource: BaseEnemyResource = ResourceLoader.load("res://Resources/Enemy/Enemy Resources/Regular/"+file)
		var resourceEncounterValue: int = loadedResource.difficultyValue
		if resourceEncounterValue <= maxValue:
			EnemyRefs.append(loadedResource)
	return EnemyRefs

func GetEnemyPositions() -> Array[Vector2]:
	var result: Array[Vector2]
	for child in get_children():
		if child.alive:
			result.append(child.global_position)
	return result
