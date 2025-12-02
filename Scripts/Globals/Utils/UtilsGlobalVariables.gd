extends Node

var enemyPositions: Array[Vector2]
var playerPosition: Vector2

var playerGrimoire: GrimoireResource

var inCombat: bool

var PlayerCastSpeed: float = 1 #Time in Seconds
var BasePlayerCastSpeed: float = 1 #Time in Seconds


var SpellPagesCastInCycleCount: int = 0
var FiredUpStacks: int = 0

var currentEnemyLevel: int = 0 #Mostly used as placeholder until proper progression mechanics

var currentGameState: UtilsGlobalEnums.gameState

var globalMusicLevel: float = -12
var globalSFXLevel: float = -24
