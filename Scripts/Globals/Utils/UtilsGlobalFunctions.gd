extends Node

func DamageCalc(BaseDamage: float) -> float:
	var totalDamage: float
	#Set Damage to Base
	totalDamage = BaseDamage
	#Split Power Curse multiplier
	totalDamage = totalDamage * UtilsGlobalVariables.SplitPowerDamageMultiplier
	#Stacked Deck Buff multiplier
	totalDamage = totalDamage * UtilsGlobalVariables.StackedDeckDamageMultiplier
	return totalDamage
