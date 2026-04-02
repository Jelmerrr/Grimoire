extends Node2D

var destination: Vector2 = Vector2(0, -600) #Needs to be here for targeting shenanigans
var spawnPos : Vector2 = Vector2(0, 150)

var pageAlignment: UtilsGlobalEnums.alignment
var pageTags: Array[UtilsGlobalEnums.pageTags]

var buffDuration: int = 1

func _ready() -> void:
	SignalBus.IgniteInflicted.connect(igniteCount)
	SignalBus.Stop_Combat.connect(onCombatEnd)
	UtilsGlobalVariables.currentIgniteChance += 999

func igniteCount() -> void:
	buffDuration -= 1
	if buffDuration == 0:
		UtilsGlobalVariables.currentIgniteChance -= 999
		queue_free()

func onCombatEnd() -> void:
	UtilsGlobalVariables.currentIgniteChance -= 999
	queue_free()
