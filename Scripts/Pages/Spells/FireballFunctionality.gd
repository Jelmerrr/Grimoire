extends CharacterBody2D

var dir : float
var spawnPos : Vector2 = Vector2(0, 150)
var spawnRot : float
var zdex : int
var damage : int = 10
var totalDamage = damage
var speed : float = 250
var destination: Vector2 = Vector2(0, -600)
var direction: Vector2
var pageAlignment: UtilsGlobalEnums.alignment
var pageTags: Array[UtilsGlobalEnums.pageTags]

var speed_tween: Tween = null
@onready var explosion_vfx: AnimatedSprite2D = $ExplosionVFX
@onready var fireball_sprite: Sprite2D = $FireballSprite

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_collision_shape_2d: CollisionShape2D = $Area2D/AreaCollisionShape2D

var playingExplosion: bool = false

@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	
	if pageAlignment == UtilsGlobalEnums.alignment.Player:
		print("Getting Angle")
		print(rad_to_deg(get_angle_to(destination)) - rad_to_deg(get_angle_to(Vector2(0, -600))))
	
	direction = global_position.direction_to(destination)
	SignalBus.Stop_Combat.connect(onCombatEnd)
	tween_speed(1000)
	
	if pageAlignment == UtilsGlobalEnums.alignment.Player:
		set_collision_layer_value(5, true)
		area_2d.set_collision_layer_value(5, true)
		set_collision_mask_value(3, true)
		area_2d.set_collision_mask_value(3, true)
		totalDamage = UtilsGlobalFunctions.DamageCalc(damage, pageTags)
	if pageAlignment == UtilsGlobalEnums.alignment.Enemy:
		set_collision_layer_value(6, true)
		area_2d.set_collision_layer_value(6, true)
		set_collision_mask_value(2, true)
		area_2d.set_collision_mask_value(2, true)
	

func onCombatEnd() -> void:
	queue_free()

func _physics_process(_delta: float) -> void:
	if !playingExplosion:
		velocity = direction * speed
	else:
		velocity = Vector2(0,0)
	move_and_slide()
	
	var collisionBody = get_last_slide_collision()
	if collisionBody != null:
		collisionBody.get_collider().Get_Damaged(self)
		play_explosion()

func play_explosion() -> void:
	playingExplosion = true
	fireball_sprite.visible = false
	collision_shape_2d.disabled = true
	area_collision_shape_2d.disabled = true
	global_position = destination
	explosion_vfx.visible = true
	explosion_vfx.play()

func tween_speed(to: float):
	if speed_tween: speed_tween.kill()
	speed_tween = get_tree().create_tween()
	speed_tween.set_ease(Tween.EASE_IN)
	speed_tween.set_trans(Tween.TRANS_QUINT)
	speed_tween.tween_property(self, "speed", to, 0.55)

func _on_life_timer_timeout() -> void:
	queue_free()

func _on_explosion_vfx_animation_finished() -> void:
	queue_free()
