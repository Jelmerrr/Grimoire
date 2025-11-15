extends CharacterBody2D

var dir : float
var spawnPos : Vector2 = Vector2(0, 150)
var spawnRot : float
var zdex : int
var damage : int = 10
var speed : float = 250
var destination: Vector2 = Vector2(0, -600)
var direction: Vector2
var pageAlignment: UtilsGlobalEnums.alignment

var speed_tween: Tween = null

@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	direction = global_position.direction_to(destination)
	SignalBus.Stop_Combat.connect(onCombatEnd)
	tween_speed(1000)
	
	if pageAlignment == UtilsGlobalEnums.alignment.Player:
		set_collision_layer_value(5, true)
		area_2d.set_collision_layer_value(5, true)
		set_collision_mask_value(3, true)
		area_2d.set_collision_mask_value(3, true)
	if pageAlignment == UtilsGlobalEnums.alignment.Enemy:
		set_collision_layer_value(6, true)
		area_2d.set_collision_layer_value(6, true)
		set_collision_mask_value(2, true)
		area_2d.set_collision_mask_value(2, true)

func onCombatEnd() -> void:
	queue_free()

func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
	
	var collisionBody = get_last_slide_collision()
	if collisionBody != null:
		collisionBody.get_collider().Get_Damaged(damage)
		queue_free()


func tween_speed(to: float):
	if speed_tween: speed_tween.kill()
	speed_tween = get_tree().create_tween()
	speed_tween.set_ease(Tween.EASE_IN)
	speed_tween.set_trans(Tween.TRANS_QUINT)
	speed_tween.tween_property(self, "speed", to, 0.55)

func _on_life_timer_timeout() -> void:
	queue_free()
