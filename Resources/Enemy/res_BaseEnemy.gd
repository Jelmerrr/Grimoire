extends Resource

class_name  BaseEnemyResource

@export var enemyName: String 
@export var baseHealth: float
@export var movementSpeed: float
@export var actionSpeed: float
@export var enemyType: UtilsGlobalEnums.enemyAttackTypes
@export var enemyAttack: PageResource
@export var enemySprite: Texture2D

@export var currentLevel: int = 1
@export var hpPerLevel: int

@export var enemyGrimoire: GrimoireResource
