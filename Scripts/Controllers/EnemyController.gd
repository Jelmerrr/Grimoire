extends Node2D

@export var enemyResource: BaseEnemyResource

var currentHealth: int
var maxHealth: int
var spawnPos: Vector2 = Vector2(0, -360)
var level: int = 1
var awake: bool = false

var currentAilments: Array[UtilsGlobalEnums.ailments]
var shockDamageInstanceCount: int
var strongestIgniteValue: float

var lastElementalTag = null

var hovering: bool = false

@onready var action_timer: Timer = $ActionTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var health_bar: ProgressBar = $"Health Bar"
@onready var mouse_area: PanelContainer = $MouseArea

@onready var ignite_duration_timer: Timer = $IgniteDurationTimer
@onready var chill_duration_timer: Timer = $ChillDurationTimer
@onready var ignite_tick_timer: Timer = $IgniteTickTimer


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
			if currentAilments.has(UtilsGlobalEnums.ailments.Chill):
				await get_tree().create_timer(enemyResource.enemyGrimoire.CastSpeed * (UtilsGlobalVariables.baseChillSlowdown/100)).timeout
			else:
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
	damage = Apply_Shock(damage)
	Adjust_Hp(damage)
	
	#Check if hit by an elemental spell for ailments.
	if projectileHit.pageTags != null:
		var tags: Array[UtilsGlobalEnums.pageTags] = projectileHit.pageTags
		var ailmentToApply: UtilsGlobalEnums.ailments
		match tags:
			[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Fire]:
				lastElementalTag = UtilsGlobalEnums.pageTags.Fire
				ailmentToApply = UtilsGlobalFunctions.Run_AilmentCheck(UtilsGlobalEnums.elements.Fire)
			[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Lightning]:
				lastElementalTag = UtilsGlobalEnums.pageTags.Lightning
				ailmentToApply = UtilsGlobalFunctions.Run_AilmentCheck(UtilsGlobalEnums.elements.Lightning)
			[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Cold]:
				lastElementalTag = UtilsGlobalEnums.pageTags.Cold
				ailmentToApply = UtilsGlobalFunctions.Run_AilmentCheck(UtilsGlobalEnums.elements.Cold)
		Apply_Ailment(ailmentToApply, damage)

func Apply_Ailment(ailment: UtilsGlobalEnums.ailments, hitDamage: float) -> void:
	match ailment:
		UtilsGlobalEnums.ailments.None:
			return
		UtilsGlobalEnums.ailments.Ignite:
			if !currentAilments.has(UtilsGlobalEnums.ailments.Ignite):
				currentAilments.append(UtilsGlobalEnums.ailments.Ignite)
				ignite_tick_timer.start()
			ignite_duration_timer.start(UtilsGlobalVariables.baseIgniteDuration * (UtilsGlobalVariables.currentIgniteDurationIncrease/100))
			if (strongestIgniteValue * (UtilsGlobalVariables.currentIgniteEffect / 100) < hitDamage * (UtilsGlobalVariables.currentIgniteEffect / 100)):
				strongestIgniteValue = hitDamage
				
		UtilsGlobalEnums.ailments.Shock:
			if !currentAilments.has(UtilsGlobalEnums.ailments.Shock): 
				currentAilments.append(UtilsGlobalEnums.ailments.Shock)
			shockDamageInstanceCount = UtilsGlobalVariables.currentShockDamageInstanceAmount
			
		UtilsGlobalEnums.ailments.Chill:
			if !currentAilments.has(UtilsGlobalEnums.ailments.Chill):
				currentAilments.append(UtilsGlobalEnums.ailments.Chill)
			chill_duration_timer.start(UtilsGlobalVariables.baseChillDuration * (UtilsGlobalVariables.currentChillDurationIncrease/100))

func Apply_Shock(damage) -> float:
	if currentAilments.has(UtilsGlobalEnums.ailments.Shock): 
		damage = damage * ((UtilsGlobalVariables.baseShockIncrease / 100) * (UtilsGlobalVariables.currentShockEffect / 100))
		shockDamageInstanceCount -= 1
		if shockDamageInstanceCount <= 0:
			currentAilments.erase(UtilsGlobalEnums.ailments.Shock)
	return damage

func Adjust_Hp(damage) -> void:
	#Round down decimal damage values (mostly relevant with Ailment calculations such as ignite)
	damage = roundi(damage)
	
	#Adjust HP values.
	currentHealth -= damage
	health_bar.value -= damage
	
	#Instaniate damage number UI.
	if damage >= 1: #Prevents showcasing 0 damage
		var damageInstance = DAMAGE_NUMBER_UI.instantiate()
		damageInstance.damageDealt = damage
		damageInstance.pos = global_position + Vector2(0,-25) #The vector should recieve a random offset based on sprite size but for now I am lazy.
		#Calling parent twice to ensure persistance should enemy die.
		self.get_parent().get_parent().add_child.call_deferred(damageInstance)
	
	#If HP is below 0 or = 0, remove enemy from scene.
	if currentHealth <= 0:
		queue_free()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if hovering == true:
				SignalBus.ShowEnemyTooltip.emit(currentHealth, maxHealth, enemyResource)

func _on_mouse_area_mouse_entered() -> void:
	hovering = true


func _on_mouse_area_mouse_exited() -> void:
	hovering = false


func _on_chill_duration_timer_timeout() -> void:
	currentAilments.erase(UtilsGlobalEnums.ailments.Chill)

func _on_ignite_duration_timer_timeout() -> void:
	currentAilments.erase(UtilsGlobalEnums.ailments.Ignite)
	ignite_tick_timer.stop()

func _on_ignite_tick_timer_timeout() -> void:
	var damage = strongestIgniteValue * (UtilsGlobalVariables.currentIgniteEffect / 100) * (UtilsGlobalVariables.currentIgniteHitPercentage / 100)
	damage = Apply_Shock(damage)
	Adjust_Hp(damage)
