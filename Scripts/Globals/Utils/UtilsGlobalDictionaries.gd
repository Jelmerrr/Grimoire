extends Node

var tooltipDict = {
	"Fire": {
		"Title": "Fire", 
		"Description": "Fire damage has a chance to ignite, dealing an additional 5% of the initial hit damage to the target every 0.25 seconds with a base duration of 3 seconds. \r\rYour base ignite chance is 5%, this can be increased with buffs and trinkets.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"Lightning": {
		"Title": "Lightning", 
		"Description": "Lightning damage has a chance to shock, making the target take 10% more damage from all sources for the next 5 times the target takes damage. \r\rThis increase in damage is calculated after all other modifiers to damage are applied. \r\rYour base shock chance is 5%, this can be increased with buffs and trinkets.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"Cold": {
		"Title": "Cold", 
		"Description": "Cold damage has a chance to chill, slowing the cast speed of the target by 10% with a base duration of 5 seconds. \r\rYour base chill chance is 10%, this can be increased with buffs and trinkets.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"Page": {
		"Title": "Page", 
		"Description": "Your grimoire is filled with pages, when a page is cast, the effect described upon the page will come true. Pages come in 5 different types.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"SpellPage": {
		"Title": "Spell Page", 
		"Description": "A spell page is 1 of 5 unique types of pages. \r\rOnce cast you deal damage according to which spell page you cast.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"BuffPage": {
		"Title": "Buff Page", 
		"Description": "A buff page is 1 of 5 unique types of pages. \r\rOnce cast gain a temporary effect that lasts for a specific amount of casts.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"CursePage": {
		"Title": "Curse Page", 
		"Description": "A curse page is 1 of 5 unique types of pages. \r\rOnce cast gain a debuff and a condition, once the condition is fullfilled, the debuff is removed and you gain a powerful temporary buff.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"Cycle": {
		"Title": "Cycle", 
		"Description": "A cycle is the total amount of pages in your Grimoire, cast in order. When you cast the last page, a cycle reset will occur. \r\rWhen this happens your Grimoire will start casting the first page in order.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"CycleReset": {
		"Title": "Cycle Reset", 
		"Description": "A cycle reset occurs at the end of a cycle. \r\rWhen the last page in your Grimoire is cast, loop back to the first page.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"DamageMultiplier": {
		"Title": "Damage Multipliers", 
		"Description": "Damage multipliers interact with each other in different ways depending on their type, unless stated otherwise on the page itself. \r\rDamage multipliers that are of the same type, stack additively. \r\rDamage multipliers that are different types, stack multiplicatively.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"CastSpeed": {
		"Title": "Casting Speed", 
		"Description": "Casting Speed is the time it takes between each cast. \r\rThe default casting speed is 1 second. \r\rYour casting speed cannot go below 0.01 seconds.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"CurseCondition": {
		"Title": "Curse Condition", 
		"Description": "The condition which needs to be fullfilled in order to be granted the benefits of a curse page.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"Combat": {
		"Title": "Combat", 
		"Description": "Combat is the phase in which you cast spells from your Grimoire in order to defeat your enemies. \r\rCombat persists until either you or they perish.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
}

var damageModifiersDict = { #In percentile
	"increasedDamage": {"Base": 100, "Current": 100, "Tag": "Global"},
	"increasedSpellDamage": {"Base": 100, "Current": 100, "Tag": "Spell"},
	"increasedLightningDamage": {"Base": 100, "Current": 100, "Tag": "Lightning"},
	"increasedFireDamage": {"Base": 100, "Current": 100, "Tag": "Fire"},
	"increasedColdDamage": {"Base": 100, "Current": 100, "Tag": "Cold"},
	"increasedDamageOverTime": {"Base": 100, "Current": 100, "Tag": "DamageOverTime"},
	"increasedAreaDamage": {"Base": 100, "Current": 100, "Tag": "AreaOfEffect"},
}

var ailmentModifiersDict = {
	"currentIgniteChance": {"Base": 5, "Current": 5, "Tag": "igniteChance"},
	"increasedIgniteEffect": {"Base": 100, "Current": 100, "Tag": "igniteEffect"},
	"currentShockChance": {"Base": 5, "Current": 5, "Tag": "shockChance"},
	"increasedShockEffect": {"Base": 100, "Current": 100, "Tag": "shockEffect"},
	"currentChillChance": {"Base": 10, "Current": 10, "Tag": "chillChance"},
	"increasedChillEffect": {"Base": 100, "Current": 100, "Tag": "chillEffect"},
}

#Add references to music here, dynamically gets loaded into the music system.
var musicLibraryDict = {
	"MainMenu": {"0": preload("uid://ciomw7vby6tbg")},
	"Stage1": {"0": preload("uid://ki0ik0e6sq41")}
}
