extends Node

func _ready() -> void:
	SignalBus.Stop_Combat.connect(ResetDamageMultipliers)

func DamageCalc(BaseDamage: float, tags: Array[UtilsGlobalEnums.pageTags], modifiersInstanceId: int) -> float:
	var tagsToString: Array[String]
	for tag in tags:
		tagsToString.append(UtilsGlobalEnums.pageTags.keys()[tag])
	var totalDamage: float
	#Set Damage to Base
	totalDamage = BaseDamage
	var modifiers: ModifiersResource = instance_from_id(modifiersInstanceId)
	
	#Add player damage multipliers to the base damage
	for multiplier in modifiers.damageModifiersDict:
		#Only apply conditional multipliers if the attack contains tags related to the multiplier
		if modifiers.damageModifiersDict[multiplier].Tag != "Global" && tagsToString.has(modifiers.damageModifiersDict[multiplier].Tag):
			totalDamage = totalDamage * (modifiers.damageModifiersDict[multiplier].Current / 100)
		#Always apply global multipliers
		if modifiers.damageModifiersDict[multiplier].Tag == "Global":
			totalDamage = totalDamage * (modifiers.damageModifiersDict[multiplier].Current / 100)
	#print(totalDamage)
	return totalDamage

func ResetDamageMultipliers() -> void:
	for multiplier in UtilsGlobalVariables.PLAYER_MODIFIERS_RESOURCE.damageModifiersDict:
		UtilsGlobalVariables.PLAYER_MODIFIERS_RESOURCE.damageModifiersDict[multiplier].Current = UtilsGlobalVariables.PLAYER_MODIFIERS_RESOURCE.damageModifiersDict[multiplier].Base

func RoundIncrease() -> void:
	UtilsGlobalVariables.currentRoundValue += 1
	if UtilsGlobalVariables.currentRoundValue == 9:
		UtilsGlobalVariables.currentRoundValue = 1
		UtilsGlobalVariables.currentStageValue += 1
	UtilsGlobalVariables.currentEnemyLevel += 1

func RoundVictory() -> void:
	SignalBus.Stop_Combat.emit()
	SignalBus.Get_New_Page.emit()
	UtilsGlobalVariables.currentGameState = UtilsGlobalEnums.gameState.Rewarding

func RoundDefeat() -> void:
	SignalBus.Stop_Combat.emit()
	UtilsGlobalVariables.currentGameState = UtilsGlobalEnums.gameState.Planning
	SignalBus.Start_Planning_Phase.emit()
	AudioControllerScene.fade_out(AudioControllerScene.music_player)
	UtilsSceneManager.switch_scene(UtilsSceneManager.TITLE_SCREEN_SCENE)
	UtilsGlobalVariables.currentStageValue = 1
	UtilsGlobalVariables.currentRoundValue = 1

func goToPlanning() -> void:
	RoundIncrease()
	UtilsGlobalVariables.currentGameState = UtilsGlobalEnums.gameState.Planning
	SignalBus.Start_Planning_Phase.emit()

func Run_AilmentCheck(element: UtilsGlobalEnums.elements) -> UtilsGlobalEnums.ailments:
	var playerModifiers = UtilsGlobalVariables.PLAYER_MODIFIERS_RESOURCE
	match element:
		UtilsGlobalEnums.elements.Fire:
			if UtilsRngHandler.rng.randf_range(1,100) <= clampf(playerModifiers.ailmentModifiersDict.igniteChance.Current, 0, 100):
				SignalBus.IgniteInflicted.emit()
				return UtilsGlobalEnums.ailments.Ignite
		UtilsGlobalEnums.elements.Lightning:
			if UtilsRngHandler.rng.randf_range(1,100) <= clampf(playerModifiers.ailmentModifiersDict.shockChance.Current, 0, 100):
				SignalBus.ShockInflicted.emit()
				return UtilsGlobalEnums.ailments.Shock
		UtilsGlobalEnums.elements.Cold:
			if UtilsRngHandler.rng.randf_range(1,100) <= clampf(playerModifiers.ailmentModifiersDict.chillChance.Current, 0, 100): 
				SignalBus.ChillInflicted.emit()
				return UtilsGlobalEnums.ailments.Chill
	return UtilsGlobalEnums.ailments.None
