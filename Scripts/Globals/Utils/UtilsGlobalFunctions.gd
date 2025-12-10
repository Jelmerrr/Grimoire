extends Node

func _ready() -> void:
	SignalBus.Stop_Combat.connect(ResetDamageMultipliers)

func DamageCalc(BaseDamage: float, tags: Array[UtilsGlobalEnums.pageTags]) -> float:
	var tagsToString: Array[String]
	for tag in tags:
		tagsToString.append(UtilsGlobalEnums.pageTags.keys()[tag])
	var totalDamage: float
	#Set Damage to Base
	totalDamage = BaseDamage
	#print(BaseDamage)
	for multiplier in UtilsGlobalDictionaries.damageModifiersDict:
		#print(multiplier + str(UtilsGlobalDictionaries.damageModifiersDict[multiplier].Current))
		if UtilsGlobalDictionaries.damageModifiersDict[multiplier].Tag != "Global" && tagsToString.has(UtilsGlobalDictionaries.damageModifiersDict[multiplier].Tag):
			totalDamage = totalDamage * (UtilsGlobalDictionaries.damageModifiersDict[multiplier].Current / 100)
		if UtilsGlobalDictionaries.damageModifiersDict[multiplier].Tag == "Global":
			totalDamage = totalDamage * (UtilsGlobalDictionaries.damageModifiersDict[multiplier].Current / 100)
	#print(totalDamage)
	return totalDamage

func ResetDamageMultipliers() -> void:
	for multiplier in UtilsGlobalDictionaries.damageModifiersDict:
		UtilsGlobalDictionaries.damageModifiersDict[multiplier].Current = UtilsGlobalDictionaries.damageModifiersDict[multiplier].Base

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

func goToPlanning() -> void:
	RoundIncrease()
	UtilsGlobalVariables.currentGameState = UtilsGlobalEnums.gameState.Planning
	SignalBus.Start_Planning_Phase.emit()
