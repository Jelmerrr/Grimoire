extends Node2D

var destination: Vector2 = Vector2(0, -600) #Needs to be here for targeting shenanigans
var spawnPos : Vector2 = Vector2(0, 150)

var pageAlignment: UtilsGlobalEnums.alignment
var pageTags: Array[UtilsGlobalEnums.pageTags]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Stop_Combat.connect(onCombatEnd)
	if UtilsGlobalVariables.FiredUpStacks < 20:
		UtilsGlobalVariables.FiredUpStacks = UtilsGlobalVariables.FiredUpStacks + 1
		var subtractor: float = UtilsGlobalVariables.PlayerCastSpeed * 0.1
		if UtilsGlobalVariables.PlayerCastSpeed - subtractor <= 0.01: #Casting speed cap
			UtilsGlobalVariables.PlayerCastSpeed = 0.01
		else:
			UtilsGlobalVariables.PlayerCastSpeed = UtilsGlobalVariables.PlayerCastSpeed - subtractor

func onCombatEnd() -> void:
	UtilsGlobalVariables.PlayerCastSpeed = UtilsGlobalVariables.BasePlayerCastSpeed
	UtilsGlobalVariables.FiredUpStacks = 0
	queue_free()
