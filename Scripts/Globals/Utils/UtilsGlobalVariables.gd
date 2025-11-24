extends Node

var enemyPositions: Array[Vector2]
var playerPosition: Vector2

var playerGrimoire: GrimoireResource

var inCombat: bool

var PlayerCastSpeed: float = 1 #Time in Seconds
var BasePlayerCastSpeed: float = 1 #Time in Seconds

var SplitPowerDamageMultiplier: float = 1
var StackedDeckDamageMultiplier: float = 1

var SpellPagesCastInCycleCount: int = 0

var currentEnemyLevel: int = 0 #Mostly used as placeholder until proper progression mechanics

var currentGameState: UtilsGlobalEnums.gameState

#Base damage increases - in percentile
var baseIncreasedDamage: float = 100
var baseIncreasedSpellDamage: float = 100
var baseIncreasedLightningDamage: float = 100
var baseIncreasedFireDamage: float = 100
var baseIncreasedColdDamage: float = 100
var baseIncreasedDamageOverTime: float = 100
var baseIncreasedAreaDamage: float = 100

#Current damage increases - in percentile
var IncreasedDamage: float = 100
var IncreasedSpellDamage: float = 100
var IncreasedLightningDamage: float = 100
var IncreasedFireDamage: float = 100
var IncreasedColdDamage: float = 100
var IncreasedDamageOverTime: float = 100
var IncreasedAreaDamage: float = 100
