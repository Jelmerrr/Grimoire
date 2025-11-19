extends Node2D

@export var enemyResource: BaseEnemyResource

var currentHealth
var spawnPos: Vector2 = Vector2(0, -360)
var level: int = 1
var awake: bool = false

@onready var action_timer: Timer = $ActionTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var health_bar: ProgressBar = $"Health Bar"

const DAMAGE_NUMBER_UI = preload("uid://cfkn2u7gp546x")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Start_Combat.connect(WakeUp)
	SignalBus.Stop_Combat.connect(Sleep)       
	currentHealth = enemyResource.baseHealth + (enemyResource.hpPerLevel * level)
	sprite_2d.texture = enemyResource.enemySprite
	health_bar.max_value = currentHealth
	health_bar.value = currentHealth
	#WakeUp()

func WakeUp() -> void:
	#Function gets called on combat start for each active enemy.
	action_timer.wait_time = enemyResource.actionSpeed
	awake = true
	action_timer.start()

func Sleep() -> void:
	#Failsafe to disable enemies should one still exist on combat end.
	action_timer.stop()
	awake = false
	#queue_free() This should be enabled after debuging and round spawning logic is done.

func _on_action_timer_timeout() -> void:
	if enemyResource.enemyAttack != null:
			var instance = enemyResource.enemyAttack.PageScene.instantiate()
			SignalBus.Ask_PlayerPos.emit()
			instance.destination = UtilsGlobalVariables.playerPosition
			instance.spawnPos = global_position
			instance.pageAlignment = UtilsGlobalEnums.alignment.Enemy
			add_child.call_deferred(instance)

func Cycle_Pages() -> void:
	for item in UtilsGlobalVariables.playerGrimoire.Pages:
		if UtilsGlobalVariables.inCombat:
			Cast_Page(item)
			await get_tree().create_timer(enemyResource.enemyGrimoire.CastSpeed).timeout
		else:
			break
	if UtilsGlobalVariables.inCombat:
		Restart_Cycle()

func Restart_Cycle() -> void:
	await get_tree().create_timer(enemyResource.enemyGrimoire.CastSpeed).timeout
	Cycle_Pages()

func Get_Damaged(BaseDamage):
	var damage = UtilsGlobalFunctions.DamageCalc(BaseDamage)
	currentHealth -= damage
	health_bar.value -= damage
	
	var damageInstance = DAMAGE_NUMBER_UI.instantiate()
	damageInstance.damageDealt = damage
	damageInstance.pos = global_position + Vector2(0,-100)
	self.get_parent().get_parent().add_child.call_deferred(damageInstance)
	
	
	if currentHealth <= 0:
		queue_free()
