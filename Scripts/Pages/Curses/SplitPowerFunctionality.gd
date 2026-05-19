extends Node2D

var debuffDuration: int = 1
var buffDuration: int = 1
var hasCurseConditionBeenFulfilled: bool = false

var modifierID: int
var modifiers: ModifiersResource
var pageOwner: Node

var preCurseMultiplierSetup

var destination: Vector2 = Vector2(0, -600) #Needs to be here for targeting shenanigans
var spawnPos : Vector2 = Vector2(0, 150)
var pageTags: Array[UtilsGlobalEnums.pageTags]

var pageAlignment: UtilsGlobalEnums.alignment

var multiplier: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modifiers = instance_from_id(modifierID)
	if modifiers.miscModifiersDict.isSplitPowerActive == true:
		queue_free()
	else:
		SignalBus.PageCasted.connect(countPage)
		SignalBus.Stop_Combat.connect(onCombatEnd)
		InitializeCurse()

func InitializeCurse() -> void:
	modifiers.miscModifiersDict.isSplitPowerActive = true
	multiplier = -50
	modifiers.damageModifiersDict.increasedDamage.Current = modifiers.damageModifiersDict.increasedDamage.Current + multiplier

func countPage(pageType: UtilsGlobalEnums.pageTypes):
	if debuffDuration <= 0 && hasCurseConditionBeenFulfilled == false:
		hasCurseConditionBeenFulfilled = true
		modifiers.damageModifiersDict.increasedDamage.Current = modifiers.damageModifiersDict.increasedDamage.Current - multiplier
		multiplier = 300
		modifiers.damageModifiersDict.increasedDamage.Current = modifiers.damageModifiersDict.increasedDamage.Current + multiplier
	if pageType == UtilsGlobalEnums.pageTypes.Spell && hasCurseConditionBeenFulfilled == false:
		debuffDuration = debuffDuration - 1
	if buffDuration <= 0:
		modifiers.damageModifiersDict.increasedDamage.Current = modifiers.damageModifiersDict.increasedDamage.Current - multiplier
		modifiers.miscModifiersDict.isSplitPowerActive = false
		queue_free()
	if pageType == UtilsGlobalEnums.pageTypes.Spell && hasCurseConditionBeenFulfilled == true:
		buffDuration = buffDuration - 1

func onCombatEnd() -> void:
	modifiers.miscModifiersDict.isSplitPowerActive = false
	queue_free()
