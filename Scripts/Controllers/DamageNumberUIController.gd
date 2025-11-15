extends Control

var damageDealt: int
var pos: Vector2
@onready var damage_number: RichTextLabel = $DamageNumber

var opacity_tween: Tween = null
var position_tween: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_number.text = str(damageDealt)
	global_position = pos
	modulate.a = 1.0
	await tween_opactiy(0.0)
	await tween_position(self.global_position + Vector2(-10, -50))

func tween_opactiy(to: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.set_ease(Tween.EASE_OUT)
	opacity_tween.tween_property(self, "modulate:a", to, 1.0)
	return opacity_tween


func tween_position(to: Vector2):
	if position_tween: position_tween.kill()
	position_tween = get_tree().create_tween()
	position_tween.set_ease(Tween.EASE_OUT)
	position_tween.tween_property(self, "global_position", to, 1.0)
	

func _on_timer_timeout() -> void:
	queue_free()
