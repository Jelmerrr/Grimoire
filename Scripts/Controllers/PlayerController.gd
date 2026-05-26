extends Node2D

@onready var health_bar: ProgressBar = $"Health Bar"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var currentHealth: int
var grimoireRef: GrimoireResource

var currentAilments: Array[UtilsGlobalEnums.ailments]
var shockDamageInstanceCount: int
var shockAppliedBy: ModifiersResource
var strongestIgniteValue: float

@onready var ignite_tick_timer: Timer = $"../IgniteTickTimer"
@onready var ignite_duration_timer: Timer = $"../IgniteDurationTimer"
@onready var chill_duration_timer: Timer = $"../ChillDurationTimer"
var igniteDamage

const DAMAGE_NUMBER_UI = preload("uid://cfkn2u7gp546x")

var lastElementalTag = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grimoireRef = UtilsGlobalVariables.playerGrimoire
	SignalBus.Ask_PlayerPos.connect(UpdatePlayerPos)
	SignalBus.Start_Combat.connect(Reset_HP)
	SignalBus.Stop_Combat.connect(Reset_HP)
	SignalBus.AddPlayerHealth.connect(Change_Health)
	Reset_HP()
	animated_sprite_2d.play()
	UtilsGlobalVariables.playerInstanceID = self

func UpdatePlayerPos() -> void:
	UtilsGlobalVariables.playerPosition = global_position

func Get_Damaged(projectileHit):
	var damageTaken = projectileHit.totalDamage
	Change_Health(-damageTaken)
	
	
	#Check if hit by an elemental spell for ailments.
	if projectileHit.pageTags != null:
		var tags: Array[UtilsGlobalEnums.pageTags] = projectileHit.pageTags
		var ailmentToApply: UtilsGlobalEnums.ailments
		var modifierID = projectileHit.modifierID
		var modifiers: ModifiersResource = instance_from_id(modifierID)
		var pageOwner = projectileHit.pageOwner
		match tags:
			[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Fire]:
				lastElementalTag = UtilsGlobalEnums.pageTags.Fire
				ailmentToApply = UtilsGlobalFunctions.Run_AilmentCheck(UtilsGlobalEnums.elements.Fire, modifierID, pageOwner)
			[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Lightning]:
				lastElementalTag = UtilsGlobalEnums.pageTags.Lightning
				ailmentToApply = UtilsGlobalFunctions.Run_AilmentCheck(UtilsGlobalEnums.elements.Lightning, modifierID, pageOwner)
			[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Cold]:
				lastElementalTag = UtilsGlobalEnums.pageTags.Cold
				ailmentToApply = UtilsGlobalFunctions.Run_AilmentCheck(UtilsGlobalEnums.elements.Cold, modifierID, pageOwner)
		Apply_Ailment(ailmentToApply, damageTaken, modifiers)
		
	#if currentHealth <= 0:
	#	queue_free()

func Apply_Ailment(ailment: UtilsGlobalEnums.ailments, hitDamage: float, modifiers: ModifiersResource) -> void:
	match ailment:
		UtilsGlobalEnums.ailments.None:
			return
		UtilsGlobalEnums.ailments.Ignite:
			if !currentAilments.has(UtilsGlobalEnums.ailments.Ignite):
				currentAilments.append(UtilsGlobalEnums.ailments.Ignite)
				ignite_tick_timer.start()
			ignite_duration_timer.start(modifiers.ailmentModifiersDict.igniteBaseDuration.Current * (modifiers.ailmentModifiersDict.igniteDurationIncrease.Current/100.0))
			if strongestIgniteValue < hitDamage: 
				strongestIgniteValue = hitDamage
			igniteDamage = strongestIgniteValue * (modifiers.ailmentModifiersDict.igniteEffect.Current / 100.0) * (modifiers.ailmentModifiersDict.ignitePercentageOfHitDamage.Current / 100)
		UtilsGlobalEnums.ailments.Shock:
			if !currentAilments.has(UtilsGlobalEnums.ailments.Shock): 
				currentAilments.append(UtilsGlobalEnums.ailments.Shock)
			shockDamageInstanceCount = modifiers.ailmentModifiersDict.shockTriggerAmount.Current
			shockAppliedBy = modifiers
			
		UtilsGlobalEnums.ailments.Chill:
			if !currentAilments.has(UtilsGlobalEnums.ailments.Chill):
				currentAilments.append(UtilsGlobalEnums.ailments.Chill)
			chill_duration_timer.start(modifiers.ailmentModifiersDict.chillBaseDuration.Current * (modifiers.ailmentModifiersDict.chillDurationIncrease.Current/100.0))


func Reset_HP() -> void:
	currentHealth = UtilsGlobalVariables.BasePlayerHealth
	health_bar.max_value = UtilsGlobalVariables.BasePlayerHealth
	health_bar.value = health_bar.max_value

func Change_Health(value: int) -> void:
	value = roundi(value)
	currentHealth = clampi(currentHealth + value, 0, UtilsGlobalVariables.BasePlayerHealth)
	health_bar.value = clampi(int(health_bar.value) + value, 0, UtilsGlobalVariables.BasePlayerHealth)
	
	value *= -1
	
	#Instaniate damage number UI.
	if value >= 1: #Prevents showcasing 0 damage
		var damageInstance = DAMAGE_NUMBER_UI.instantiate()
		damageInstance.damageDealt = value
		damageInstance.pos = global_position + Vector2(0,-25) #The vector should recieve a random offset based on sprite size but for now I am lazy.
		#Calling parent twice to ensure persistance should you die.
		self.get_parent().get_parent().add_child.call_deferred(damageInstance)
	
	if currentHealth == 0:
		UtilsGlobalFunctions.RoundDefeat()


func _on_ignite_duration_timer_timeout() -> void:
	currentAilments.erase(UtilsGlobalEnums.ailments.Ignite)
	ignite_tick_timer.stop()


func _on_ignite_tick_timer_timeout() -> void: 
	var damage = Apply_Shock(igniteDamage)
	Change_Health(-damage)

func Apply_Shock(damage) -> float:
	if currentAilments.has(UtilsGlobalEnums.ailments.Shock): 
		damage = damage * ((shockAppliedBy.ailmentModifiersDict.shockBaseDamageIncrease.Current / 100.0) * (shockAppliedBy.ailmentModifiersDict.shockEffect.Current / 100.0))
		shockDamageInstanceCount -= 1
		if shockDamageInstanceCount <= 0:
			currentAilments.erase(UtilsGlobalEnums.ailments.Shock)
	return damage

func _on_chill_duration_timer_timeout() -> void:
	currentAilments.erase(UtilsGlobalEnums.ailments.Chill)
