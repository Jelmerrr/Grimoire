extends Node

var enemyPositions: Array[Vector2]
var playerPosition: Vector2

var playerGrimoire: GrimoireResource

#Game state variables
var inCombat: bool
var currentGameState: UtilsGlobalEnums.gameState
var currentStageValue: int = 1
var currentRoundValue: int = 1

#Player stat variables
var PlayerCastSpeed: float = 1 #Time in Seconds
var BasePlayerCastSpeed: float = 1 #Time in Seconds
var BasePlayerHealth: int = 100

#Page specific variables
var SpellPagesCastInCycleCount: int = 0
var FiredUpStacks: int = 0
var IsSplitPowerActive: bool = false

#Enemy stat variables
var currentEnemyLevel: int = 1 #Mostly used as placeholder until proper progression mechanics

#Option variables
var MusicBusLevel: float = 0
var SFXBusLevel: float = 0
