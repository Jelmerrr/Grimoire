extends Control

var opacity_tween: Tween = null
@onready var stage_number: RichTextLabel = $VBoxContainer/GradientRect/TextHBoxContainer/TextMargin/MarginContainer/VBoxContainer/StageNumber

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	SignalBus.Start_Planning_Phase.connect(showTransition)

func showTransition() -> void:
	stage_number.text = str(UtilsGlobalVariables.currentStageValue) + " - " + str(UtilsGlobalVariables.currentRoundValue)
	modulate.a = 0.0
	await tween_opactiy(1.0).finished
	await get_tree().create_timer(3).timeout
	hideTransition()

func hideTransition() -> void:
	modulate.a = 1.0
	await tween_opactiy(0.0)

func tween_opactiy(to: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, 0.5)
	opacity_tween.set_ease(Tween.EASE_IN_OUT)
	return opacity_tween
