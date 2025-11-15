extends Node2D

@onready var health_bar: ProgressBar = $"Health Bar"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Ask_PlayerPos.connect(UpdatePlayerPos)
	health_bar.value = health_bar.max_value

func UpdatePlayerPos() -> void:
	UtilsGlobalVariables.playerPosition = global_position

func Get_Damaged(BaseDamage):
	print(BaseDamage)
	#var damage = UtilsGlobalFunctions.DamageCalc(BaseDamage)
	#currentHealth -= damage
	#health_bar.value -= damage
	
	#if currentHealth <= 0:
	#	queue_free()
