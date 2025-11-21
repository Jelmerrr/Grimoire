extends Node2D

var destination: Vector2 = Vector2(0, -600) #Needs to be here for targeting shenanigans
var spawnPos : Vector2 = Vector2(0, 150)

var pageAlignment: UtilsGlobalEnums.alignment
var pageTags: Array[UtilsGlobalEnums.pageTags]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.CyclePages.connect(ResetOnCycle)
	SignalBus.Stop_Combat.connect(onCombatEnd)
	UtilsGlobalVariables.StackedDeckDamageMultiplier = 1
	var multiplier: float = 1 + (0.25 * UtilsGlobalVariables.SpellPagesCastInCycleCount)
	UtilsGlobalVariables.StackedDeckDamageMultiplier = multiplier

func ResetOnCycle() -> void:
	UtilsGlobalVariables.StackedDeckDamageMultiplier = 1
	queue_free()

func onCombatEnd() -> void:
	UtilsGlobalVariables.StackedDeckDamageMultiplier = 1
	queue_free()
