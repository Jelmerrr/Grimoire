extends Node

var tooltipDict = {
	"Fire": {
		"Title": "Fire", 
		"Description": "When an enemy is hit by 2 elemental damage instances, unique effects happen. \r\rFire + Fire = Burst. \r(Deal 150% of hit damage in an area) \r\r Fire + Lightning = Scorch. \r(Deal 10% of the targets max health every second for 3 seconds) \r\r Fire + Cold = Brittle. \r(The target takes 25% more damage for 5 seconds)", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"Lightning": {
		"Title": "Lightning", 
		"Description": "When an enemy is hit by 2 elemental damage instances, unique effects happen.", 
		"Icon": "res://Assets/Icons/fire-icon.png"
		},
	"Cold": {
		"Title": "Cold", 
		"Description": "When an enemy is hit by 2 elemental damage instances, unique effects happen.", 
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
		"Description": "Damage multipliers interact with each other in different ways depending on their sources, unless stated otherwise in the page itself. \r\rDamage multipliers originating from the same source, stack additively. \r\rDamage multipliers originating from different sources, stack multiplicatively.", 
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
