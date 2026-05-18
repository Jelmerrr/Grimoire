extends Resource

class_name ModifiersResource

@export var damageModifiersDict = { #In percentile
	"increasedDamage": {"Base": 100.0, "Current": 100.0, "Tag": "Global"},
	"increasedSpellDamage": {"Base": 100.0, "Current": 100.0, "Tag": "Spell"},
	"increasedLightningDamage": {"Base": 100.0, "Current": 100.0, "Tag": "Lightning"},
	"increasedFireDamage": {"Base": 100.0, "Current": 100.0, "Tag": "Fire"},
	"increasedColdDamage": {"Base": 100.0, "Current": 100.0, "Tag": "Cold"},
	"increasedDamageOverTime": {"Base": 100.0, "Current": 100.0, "Tag": "DamageOverTime"},
	"increasedAreaDamage": {"Base": 100.0, "Current": 100.0, "Tag": "AreaOfEffect"},
}

@export var ailmentModifiersDict = {
	"igniteChance": {"Base": 5.0, "Current": 5.0, "Tag": "igniteChance"},
	"igniteEffect": {"Base": 100.0, "Current": 100.0, "Tag": "igniteEffect"},
	"igniteBaseDuration": {"Base": 4.0, "Current": 4.0, "Tag": "igniteDuration"},
	"igniteDurationIncrease": {"Base": 100.0, "Current": 100.0, "Tag": "igniteDurationIncrease"},
	"ignitePercentageOfHitDamage": {"Base": 10.0, "Current": 10.0, "Tag": "igniteHitDamage"},
	"shockChance": {"Base": 5.0, "Current": 5.0, "Tag": "shockChance"},
	"shockEffect": {"Base": 100.0, "Current": 100.0, "Tag": "shockEffect"},
	"shockBaseDamageIncrease": {"Base": 110.0, "Current": 110.0, "Tag": "shockDamage"},
	"shockTriggerAmount": {"Base": 5.0, "Current": 5.0, "Tag": "shockAmount"},
	"chillChance": {"Base": 10.0, "Current": 10.0, "Tag": "chillChance"},
	"chillEffect": {"Base": 100.0, "Current": 100.0, "Tag": "chillEffect"},
	"chillBaseDuration": {"Base": 5.0, "Current": 5.0, "Tag": "chillDuration"},
	"chillDurationIncrease": {"Base": 100.0, "Current": 100.0, "Tag": "chillDuration"},
	"chillBaseSlowdown": {"Base": 10.0, "Current": 10.0, "Tag": "chillBaseSlowdown"},
}

@export var miscModifiersDict = {
	"firedUpStacks": 0,
	"isSplitPowerActive": false,
}
