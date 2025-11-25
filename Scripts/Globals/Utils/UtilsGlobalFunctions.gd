extends Node

func DamageCalc(BaseDamage: float) -> float:
	var totalDamage: float
	#Set Damage to Base
	totalDamage = BaseDamage
	for multiplier in UtilsGlobalDictionaries.damageModifiersDict:
		totalDamage = totalDamage * (UtilsGlobalDictionaries.damageModifiersDict[multiplier].Current / 100)
	return totalDamage
