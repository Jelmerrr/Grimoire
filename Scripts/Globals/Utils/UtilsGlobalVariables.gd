extends Node

var enemyPositions: Array[Vector2]
var playerPosition: Vector2

var playerGrimoire: GrimoireResource

#Game state variables
var inCombat: bool
var currentGameState: UtilsGlobalEnums.gameState

#Player stat variables
var PlayerCastSpeed: float = 1 #Time in Seconds
var BasePlayerCastSpeed: float = 1 #Time in Seconds

#Page specific variables
var SpellPagesCastInCycleCount: int = 0
var FiredUpStacks: int = 0
var IsSplitPowerActive: bool = false

#Enemy stat variables
var currentEnemyLevel: int = 0 #Mostly used as placeholder until proper progression mechanics

#Option variables
var globalMusicLevel: float = -12
var globalSFXLevel: float = -12
