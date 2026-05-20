extends Node2D

var destination: Vector2 = Vector2(0, -600) #Needs to be here for targeting shenanigans
var spawnPos : Vector2 = Vector2(0, 150)

var modifierID: int
var modifiers: ModifiersResource
var pageOwner: Node

var subtractor: float

var pageAlignment: UtilsGlobalEnums.alignment
var pageTags: Array[UtilsGlobalEnums.pageTags]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modifiers = instance_from_id(modifierID)
	SignalBus.Stop_Combat.connect(onCombatEnd)
	if modifiers.miscModifiersDict.firedUpStacks < 20:
		modifiers.miscModifiersDict.firedUpStacks += 1
		subtractor = pageOwner.grimoireRef.CastSpeed * 0.1
		if pageOwner.grimoireRef.CastSpeed - subtractor <= 0.01: #Casting speed cap
			pageOwner.grimoireRef.CastSpeed = 0.01
		else:
			pageOwner.grimoireRef.CastSpeed = pageOwner.grimoireRef.CastSpeed - subtractor

func onCombatEnd() -> void:
	queue_free()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			on_predelete()

func on_predelete() -> void:
	pageOwner.grimoireRef.CastSpeed = pageOwner.grimoireRef.BaseCastSpeed
	modifiers.miscModifiersDict.firedUpStacks = 0
