extends Resource

class_name  BaseEnemyResource

@export var enemyName: String 
@export var baseHealth: float
@export var movementSpeed: float
@export var actionSpeed: float
@export var enemyType: UtilsGlobalEnums.enemyAttackTypes
@export var enemySprite: Texture2D

@export var difficultyValue: int #Base judgement of enemy difficulty
@export var additionalDifficultyIncrease: int = 0 #Leftover difficulty allowance is randomly spread between enemies
@export var additionalDifficultyHpScaling: int = 5 #Measures increase in HP based on leftover difficulty scaling

@export var enemyGrimoire: GrimoireResource
