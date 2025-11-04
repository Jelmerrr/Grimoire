extends Node2D

@export var enemyResource: BaseEnemyResource

var currentHealth
var spawnPos: Vector2 = Vector2(0, -360)

@onready var action_timer: Timer = $ActionTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var health_bar: ProgressBar = $"Health Bar"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Start_Combat.connect(WakeUp)
	SignalBus.Stop_Combat.connect(Sleep)       #Placeholder scaling below, remove later.
	currentHealth = enemyResource.maxHealth * (0.5 * UtilsGlobalVariables.currentEnemyLevel)
	sprite_2d.texture = enemyResource.enemySprite
	health_bar.max_value = currentHealth
	health_bar.value = currentHealth
	WakeUp()

func WakeUp() -> void:
	#Function gets called on combat start for each active enemy.
	action_timer.wait_time = enemyResource.actionSpeed
	action_timer.start()

func Sleep() -> void:
	#Failsafe to disable enemies should one still exist on combat end.
	action_timer.stop()
	#queue_free() This should be enabled after debuging and round spawning logic is done.

func _on_action_timer_timeout() -> void:
	if enemyResource.enemyAttack != null:
			var instance = enemyResource.enemyAttack.PageScene.instantiate()
			SignalBus.Ask_PlayerPos.emit()
			instance.destination = UtilsGlobalVariables.playerPosition
			instance.spawnPos = global_position
			instance.pageAlignment = UtilsGlobalEnums.alignment.Enemy
			add_child.call_deferred(instance)

func Get_Damaged(BaseDamage):
	var damage = UtilsGlobalFunctions.DamageCalc(BaseDamage)
	currentHealth -= damage
	health_bar.value -= damage
	
	if currentHealth <= 0:
		queue_free()
