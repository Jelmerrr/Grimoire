extends Node2D

@onready var health_bar: ProgressBar = $"Health Bar"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var currentHealth: int
var grimoireRef: GrimoireResource

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
	
	var damageInstance = DAMAGE_NUMBER_UI.instantiate()
	damageInstance.damageDealt = damageTaken
	damageInstance.pos = global_position + Vector2(0,-25) #The vector should recieve a random offset based on sprite size but for now I am lazy.
	#Calling parent twice to ensure persistance should you die.
	self.get_parent().get_parent().add_child.call_deferred(damageInstance)
	
	#Check if hit by an elemental spell for ailments.
	if projectileHit.pageTags != null:
		var tags: Array[UtilsGlobalEnums.pageTags] = projectileHit.pageTags
		var ailmentToApply: UtilsGlobalEnums.ailments
		var playerModifierID = UtilsGlobalVariables.PLAYER_MODIFIERS_RESOURCE.get_instance_id()
		match tags:
			[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Fire]:
				lastElementalTag = UtilsGlobalEnums.pageTags.Fire
				ailmentToApply = UtilsGlobalFunctions.Run_AilmentCheck(UtilsGlobalEnums.elements.Fire, playerModifierID)
			[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Lightning]:
				lastElementalTag = UtilsGlobalEnums.pageTags.Lightning
				ailmentToApply = UtilsGlobalFunctions.Run_AilmentCheck(UtilsGlobalEnums.elements.Lightning, playerModifierID)
			[UtilsGlobalEnums.pageTags.Spell, UtilsGlobalEnums.pageTags.Cold]:
				lastElementalTag = UtilsGlobalEnums.pageTags.Cold
				ailmentToApply = UtilsGlobalFunctions.Run_AilmentCheck(UtilsGlobalEnums.elements.Cold, playerModifierID)
		#Apply_Ailment(ailmentToApply, damage)
		
	#if currentHealth <= 0:
	#	queue_free()

func Reset_HP() -> void:
	currentHealth = UtilsGlobalVariables.BasePlayerHealth
	health_bar.max_value = UtilsGlobalVariables.BasePlayerHealth
	health_bar.value = health_bar.max_value

func Change_Health(value: int) -> void:
	value = roundi(value)
	currentHealth = clampi(currentHealth + value, 0, UtilsGlobalVariables.BasePlayerHealth)
	health_bar.value = clampi(int(health_bar.value) + value, 0, UtilsGlobalVariables.BasePlayerHealth)
	if currentHealth == 0:
		UtilsGlobalFunctions.RoundDefeat()
