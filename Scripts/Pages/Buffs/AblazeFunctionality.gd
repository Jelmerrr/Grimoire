extends Node2D

var destination: Vector2 = Vector2(0, -600) #Needs to be here for targeting shenanigans
var spawnPos : Vector2 = Vector2(0, 150)

var modifierID: int
var modifiers: ModifiersResource
var pageOwner: Node

var pageAlignment: UtilsGlobalEnums.alignment
var pageTags: Array[UtilsGlobalEnums.pageTags]

var buffDuration: int = 1

func _ready() -> void:
	modifiers = instance_from_id(modifierID)
	SignalBus.IgniteInflicted.connect(igniteCount)
	SignalBus.Stop_Combat.connect(onCombatEnd)
	modifiers.ailmentModifiersDict.igniteChance.Current += 999
	#UtilsGlobalVariables.currentIgniteChance += 999

func igniteCount(ownerRef: Node) -> void:
	if ownerRef == pageOwner:
		buffDuration -= 1
		if buffDuration == 0:
		#UtilsGlobalVariables.currentIgniteChance -= 999
			queue_free()

func onCombatEnd() -> void:
	#UtilsGlobalVariables.currentIgniteChance -= 999
	queue_free()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			on_predelete()

func on_predelete() -> void:
	modifiers.ailmentModifiersDict.igniteChance.Current -= 999
