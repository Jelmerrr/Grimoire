extends Node2D

@onready var health_bar: ProgressBar = $"Health Bar"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var current_health: int

const DAMAGE_NUMBER_UI = preload("uid://cfkn2u7gp546x")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Ask_PlayerPos.connect(UpdatePlayerPos)
	SignalBus.Start_Combat.connect(Reset_HP)
	SignalBus.Stop_Combat.connect(Reset_HP)
	SignalBus.AddPlayerHealth.connect(Change_Health)
	Reset_HP()
	animated_sprite_2d.play()

func UpdatePlayerPos() -> void:
	UtilsGlobalVariables.playerPosition = global_position

func Get_Damaged(enemySpell):
	var damageTaken = enemySpell.damage
	Change_Health(-damageTaken)
	
	var damageInstance = DAMAGE_NUMBER_UI.instantiate()
	damageInstance.damageDealt = damageTaken
	damageInstance.pos = global_position + Vector2(0,-100) #The vector should recieve a random offset based on sprite size but for now I am lazy.
	#Calling parent twice to ensure persistance should you die.
	self.get_parent().get_parent().add_child.call_deferred(damageInstance)
	
	#if currentHealth <= 0:
	#	queue_free()

func Reset_HP() -> void:
	current_health = UtilsGlobalVariables.BasePlayerHealth
	health_bar.max_value = UtilsGlobalVariables.BasePlayerHealth
	health_bar.value = health_bar.max_value

func Change_Health(value: int) -> void:
	current_health = clampi(current_health + value, 0, UtilsGlobalVariables.BasePlayerHealth)
	health_bar.value = clampi(int(health_bar.value) + value, 0, UtilsGlobalVariables.BasePlayerHealth)
	print(health_bar.value)
	if current_health == 0:
		UtilsGlobalFunctions.RoundDefeat()
