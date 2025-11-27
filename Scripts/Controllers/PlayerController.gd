extends Node2D

@onready var health_bar: ProgressBar = $"Health Bar"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Ask_PlayerPos.connect(UpdatePlayerPos)
	health_bar.value = health_bar.max_value
	animated_sprite_2d.play()

func UpdatePlayerPos() -> void:
	UtilsGlobalVariables.playerPosition = global_position

func Get_Damaged(enemySpell):
	pass
	#print(BaseDamage)
	#var damage = UtilsGlobalFunctions.DamageCalc(BaseDamage)
	#currentHealth -= damage
	#health_bar.value -= damage
	
	#if currentHealth <= 0:
	#	queue_free()
