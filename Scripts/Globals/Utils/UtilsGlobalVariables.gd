extends Node

var enemyPositions: Array[Vector2]
var playerPosition: Vector2

var inCombat: bool

var PlayerCastSpeed: float = 1 #Time in Seconds
var BasePlayerCastSpeed: float = 1 #Time in Seconds

var SplitPowerDamageMultiplier: float = 1
var StackedDeckDamageMultiplier: float = 1

var SpellPagesCastInCycleCount: int = 0

var currentEnemyLevel: int = 0 #Mostly used as placeholder until proper progression mechanics
