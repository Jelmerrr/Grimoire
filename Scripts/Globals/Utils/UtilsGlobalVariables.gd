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

#Player ailment variables
var baseIgniteChance: float = 5
var currentIgniteChance: float = 5
var baseShockChance: float = 5
var currentShockChance: float = 5
var baseChillChance: float = 10
var currentChillChance: float = 10

var baseIgniteEffect: float = 100
var currentIgniteEffect: float = 100
var baseShockEffect: float = 100
var currentShockEffect: float = 100
var baseChillEffect: float = 100
var currentChillEffect: float = 100

var baseIgniteDamage: float = 10
var baseShockIncrease: float = 110

#Page specific variables
var SpellPagesCastInCycleCount: int = 0
var FiredUpStacks: int = 0
var IsSplitPowerActive: bool = false

#Enemy stat variables
var currentEnemyLevel: int = 1 #Mostly used as placeholder until proper progression mechanics

#Option variables
var MusicBusLevel: float = 0
var SFXBusLevel: float = 0
