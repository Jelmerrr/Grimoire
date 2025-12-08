extends Node2D

@onready var health_bar: ProgressBar = $"Health Bar"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var current_health: int

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
		print("Lost combat")
		SignalBus.Stop_Combat.emit()
		UtilsGlobalVariables.currentEnemyLevel -= 1
		UtilsGlobalVariables.currentGameState = UtilsGlobalEnums.gameState.Planning
		SignalBus.Start_Planning_Phase.emit()
