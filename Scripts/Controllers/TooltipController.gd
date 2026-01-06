extends Node2D

const GLOBAL_TOOLTIP_UI = preload("uid://nl1m2y530y56")
@onready var control: Control = $Control

func _ready() -> void:
	SignalBus.ShowTooltip.connect(showTooltip)

func showTooltip(tooltipType: String) -> void:
	var instance = GLOBAL_TOOLTIP_UI.instantiate()
	instance.tooltipType = tooltipType
	control.add_child.call_deferred(instance)
