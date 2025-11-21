extends Node2D

@export var enemyResource: BaseEnemyResource

var currentHealth
var spawnPos: Vector2 = Vector2(0, -360)
var level: int = 1
var awake: bool = false

var lastElementalTag: UtilsGlobalEnums.pageTags

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
	Restart_Cycle()
	action_timer.start()

func Sleep() -> void:
	#Failsafe to disable enemies should one still exist on combat end.
	action_timer.stop()
	awake = false
	#queue_free() This should be enabled after debuging and round spawning logic is done.

func Cycle_Pages() -> void:
	for page in enemyResource.enemyGrimoire.Pages:
		if awake:
			Cast_Page(page)
			await get_tree().create_timer(enemyResource.enemyGrimoire.CastSpeed).timeout
		else:
			break
	if awake:
		Restart_Cycle()

func Cast_Page(page: PageResource) -> void:
	var instance = page.PageScene.instantiate()
	SignalBus.Ask_PlayerPos.emit()
	instance.destination = UtilsGlobalVariables.playerPosition
	instance.spawnPos = global_position
	instance.pageAlignment = UtilsGlobalEnums.alignment.Enemy
	add_child.call_deferred(instance)

func Restart_Cycle() -> void:
	await get_tree().create_timer(enemyResource.enemyGrimoire.CastSpeed).timeout
	Cycle_Pages()

func Get_Damaged(projectileHit):
	var baseDamage = projectileHit.damage
	var damage = UtilsGlobalFunctions.DamageCalc(baseDamage)
	currentHealth -= damage
	health_bar.value -= damage
	
	var damageInstance = DAMAGE_NUMBER_UI.instantiate()
	damageInstance.damageDealt = damage
	damageInstance.pos = global_position + Vector2(0,-100)
	self.get_parent().get_parent().add_child.call_deferred(damageInstance)
	
	if currentHealth <= 0:
		queue_free()
	elif projectileHit.pageTags != null:
		var tags: Array[UtilsGlobalEnums.pageTags] = projectileHit.pageTags
		if lastElementalTag == null:
			#Fire check
			if tags.has(UtilsGlobalEnums.pageTags.Spell) && tags.has(UtilsGlobalEnums.pageTags.Fire):
				lastElementalTag = UtilsGlobalEnums.pageTags.Fire
			#Lightning check
			if tags.has(UtilsGlobalEnums.pageTags.Spell) && tags.has(UtilsGlobalEnums.pageTags.Lightning):
				lastElementalTag = UtilsGlobalEnums.pageTags.Fire
			#Cold check
			if tags.has(UtilsGlobalEnums.pageTags.Spell) && tags.has(UtilsGlobalEnums.pageTags.Cold):
				lastElementalTag = UtilsGlobalEnums.pageTags.Fire
		elif lastElementalTag != null:
			if lastElementalTag == UtilsGlobalEnums.pageTags.Fire:
				pass
			if lastElementalTag == UtilsGlobalEnums.pageTags.Lightning:
				pass
			if lastElementalTag == UtilsGlobalEnums.pageTags.Cold:
				pass
