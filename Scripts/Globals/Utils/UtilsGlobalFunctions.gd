extends Node

func _ready() -> void:
	SignalBus.Stop_Combat.connect(ResetDamageMultipliers)

func DamageCalc(BaseDamage: float) -> float:
	var totalDamage: float
	#Set Damage to Base
	totalDamage = BaseDamage
	#print(BaseDamage)
	for multiplier in UtilsGlobalDictionaries.damageModifiersDict:
		#print(multiplier + str(UtilsGlobalDictionaries.damageModifiersDict[multiplier].Current))
		totalDamage = totalDamage * (UtilsGlobalDictionaries.damageModifiersDict[multiplier].Current / 100)
	#print(totalDamage)
	return totalDamage

func ResetDamageMultipliers() -> void:
	for multiplier in UtilsGlobalDictionaries.damageModifiersDict:
		UtilsGlobalDictionaries.damageModifiersDict[multiplier].Current = UtilsGlobalDictionaries.damageModifiersDict[multiplier].Base
