extends Node2D

var debuffDuration: int = 1
var buffDuration: int = 1
var hasCurseConditionBeenFulfilled: bool = false

var preCurseMultiplierSetup

var destination: Vector2 = Vector2(0, -600) #Needs to be here for targeting shenanigans
var spawnPos : Vector2 = Vector2(0, 150)
var pageTags: Array[UtilsGlobalEnums.pageTags]

var pageAlignment: UtilsGlobalEnums.alignment

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.PageCasted.connect(countPage)
	SignalBus.Stop_Combat.connect(onCombatEnd)
	InitializeCurse()

func InitializeCurse() -> void:
	UtilsGlobalVariables.SplitPowerDamageMultiplier = 0.5

func countPage(pageType: UtilsGlobalEnums.pageTypes):
	if debuffDuration <= 0 && hasCurseConditionBeenFulfilled == false:
		hasCurseConditionBeenFulfilled = true
		UtilsGlobalVariables.SplitPowerDamageMultiplier = 3.0
	if pageType == UtilsGlobalEnums.pageTypes.Spell && hasCurseConditionBeenFulfilled == false:
		debuffDuration = debuffDuration - 1
	if buffDuration <= 0:
		UtilsGlobalVariables.SplitPowerDamageMultiplier = 1.0
		queue_free()
	if pageType == UtilsGlobalEnums.pageTypes.Spell && hasCurseConditionBeenFulfilled == true:
		buffDuration = buffDuration - 1

func onCombatEnd() -> void:
	UtilsGlobalVariables.SplitPowerDamageMultiplier = 1.0
	queue_free()
