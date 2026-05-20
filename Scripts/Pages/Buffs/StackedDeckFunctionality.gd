extends Node2D

var destination: Vector2 = Vector2(0, -600) #Needs to be here for targeting shenanigans
var spawnPos : Vector2 = Vector2(0, 150)

var modifierID: int
var modifiers: ModifiersResource
var pageOwner: Node

var pageAlignment: UtilsGlobalEnums.alignment
var pageTags: Array[UtilsGlobalEnums.pageTags]

var multiplier: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modifiers = instance_from_id(modifierID)
	SignalBus.CyclePages.connect(ResetOnCycle)
	SignalBus.Stop_Combat.connect(onCombatEnd)
	multiplier = multiplier + (25 * UtilsGlobalVariables.SpellPagesCastInCycleCount)
	modifiers.damageModifiersDict.increasedSpellDamage.Current = modifiers.damageModifiersDict.increasedSpellDamage.Current + multiplier

func ResetOnCycle(pageOwnerRef: Node) -> void:
	if pageOwner == pageOwnerRef:
		modifiers.damageModifiersDict.increasedSpellDamage.Current = modifiers.damageModifiersDict.increasedSpellDamage.Current - multiplier
		queue_free()

func onCombatEnd() -> void:
	queue_free()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			on_predelete()

func on_predelete() -> void:
	pass
