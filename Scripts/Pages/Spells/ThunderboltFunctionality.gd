extends Node2D

var destination: Vector2 = Vector2(0, -600)
var spawnPos : Vector2 = Vector2(0, 150)
var damage : int = 15
var totalDamage = damage
@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var pageAlignment: UtilsGlobalEnums.alignment

var pageTags: Array[UtilsGlobalEnums.pageTags]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#area_2d.position = destination
	AudioControllerScene.playSFX(preload("uid://b4xtgwes6v5id"))
	position = destination
	animated_sprite_2d.play()
	SignalBus.Stop_Combat.connect(onCombatEnd)
	if pageAlignment == UtilsGlobalEnums.alignment.Player:
		area_2d.set_collision_layer_value(2, true)
		totalDamage = UtilsGlobalFunctions.DamageCalc(damage, pageTags)
	elif pageAlignment == UtilsGlobalEnums.alignment.Enemy:
		area_2d.set_collision_layer_value(4, true)

func _on_life_timer_timeout() -> void:
	queue_free()

func onCombatEnd() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.Get_Damaged(self)
