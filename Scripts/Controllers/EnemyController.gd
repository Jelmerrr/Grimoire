extends Node2D

@export var enemyResource: BaseEnemyResource

var currentHealth: int
var maxHealth: int
var spawnPos: Vector2 = Vector2(0, -360)
var level: int = 1
var awake: bool = false

var lastElementalTag = null

var hovering: bool = false

@onready var action_timer: Timer = $ActionTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var health_bar: ProgressBar = $"Health Bar"
@onready var mouse_area: PanelContainer = $MouseArea

const DAMAGE_NUMBER_UI = preload("uid://cfkn2u7gp546x")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Start_Combat.connect(WakeUp)
	SignalBus.Stop_Combat.connect(Sleep)
	
	maxHealth = int(enemyResource.baseHealth + (enemyResource.hpPerLevel * level))
	currentHealth = maxHealth
	sprite_2d.texture = enemyResource.enemySprite
	health_bar.max_value = currentHealth
	health_bar.value = currentHealth
	mouse_area.size = sprite_2d.texture.get_size() * 2
	mouse_area.position = sprite_2d.position
	mouse_area.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE)

func WakeUp() -> void:
	#Function gets called on combat start for each active enemy.
	action_timer.wait_time = enemyResource.actionSpeed
	awake = true
	Restart_Cycle()
	action_timer.start()

func Sleep() -> void:
	#Failsafe to disable enemies should one still exist on combat end.
	#This should realistically never trigger, if it does, some shit went down.
	action_timer.stop()
	awake = false
	queue_free()

func Cycle_Pages() -> void:
	#Grimoire cycle logic.
	#TODO: Dynamic action speed and decision tree stuff.
	for page in enemyResource.enemyGrimoire.Pages:
		if awake:
			Cast_Page(page)
			await get_tree().create_timer(enemyResource.enemyGrimoire.CastSpeed).timeout
		else:
			break
	if awake:
		Restart_Cycle()

func Cast_Page(page: PageResource) -> void:
	#Instaniate page and add it as a child object.
	var instance = page.PageScene.instantiate()
	SignalBus.Ask_PlayerPos.emit()
	instance.destination = UtilsGlobalVariables.playerPosition
	instance.spawnPos = global_position
	instance.pageAlignment = UtilsGlobalEnums.alignment.Enemy
	#Calling parent twice to ensure persistance should enemy die.
	self.get_parent().get_parent().add_child.call_deferred(instance)

func Restart_Cycle() -> void:
	#Loops back to the beginning after the last page of a cycle is cast.
	await get_tree().create_timer(enemyResource.enemyGrimoire.CastSpeed).timeout
	Cycle_Pages()

func Get_Damaged(projectileHit):
	#Damage calculations for enemies.
	
	#Apply damage multipliers to base damage of the projectile.
	var damage = projectileHit.totalDamage
	
	#Adjust HP values.
	currentHealth -= damage
	health_bar.value -= damage
	
	#Instaniate damage number UI.
	var damageInstance = DAMAGE_NUMBER_UI.instantiate()
	damageInstance.damageDealt = damage
	damageInstance.pos = global_position + Vector2(0,-100) #The vector should recieve a random offset based on sprite size but for now I am lazy.
	#Calling parent twice to ensure persistance should enemy die.
	self.get_parent().get_parent().add_child.call_deferred(damageInstance)
	
	#If HP is below 0 or = 0, remove enemy from scene.
	if currentHealth <= 0:
		queue_free()
	
	#Big switch statement that handles the elemental synergies system.
	if projectileHit.pageTags != null:
		var tags: Array[UtilsGlobalEnums.pageTags] = projectileHit.pageTags
		match lastElementalTag:
			UtilsGlobalEnums.pageTags.Fire:
				match tags:
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Fire]:
						print("Burst")
						lastElementalTag = null
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Lightning]:
						print("Scorch")
						lastElementalTag = null
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Cold]:
						print("Brittle")
						lastElementalTag = null
			UtilsGlobalEnums.pageTags.Lightning:
				match tags:
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Fire]:
						print("Scorch")
						lastElementalTag = null
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Lightning]:
						print("Conduct")
						lastElementalTag = null
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Cold]:
						print("Shock")
						lastElementalTag = null
			UtilsGlobalEnums.pageTags.Cold:
				match tags:
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Fire]:
						print("Brittle")
						lastElementalTag = null
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Lightning]:
						print("Shock")
						lastElementalTag = null
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Cold]:
						print("Freeze")
						lastElementalTag = null
			_:
				match tags:
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Fire]:
						lastElementalTag = UtilsGlobalEnums.pageTags.Fire
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Lightning]:
						lastElementalTag = UtilsGlobalEnums.pageTags.Lightning
					[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Cold]:
						lastElementalTag = UtilsGlobalEnums.pageTags.Cold

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if hovering == true:
				SignalBus.ShowEnemyTooltip.emit(currentHealth, maxHealth, enemyResource)


func _on_mouse_area_mouse_entered() -> void:
	hovering = true


func _on_mouse_area_mouse_exited() -> void:
	hovering = false
