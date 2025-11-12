extends Control

var damageDealt: int
var pos: Vector2
@onready var damage_number: RichTextLabel = $DamageNumber

var opacity_tween: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_number.text = str(damageDealt)
	global_position = pos
	modulate.a = 1.0
	await tween_opactiy(0.0)

func tween_opactiy(to: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, 1.0)
	return opacity_tween


func _on_timer_timeout() -> void:
	queue_free()
