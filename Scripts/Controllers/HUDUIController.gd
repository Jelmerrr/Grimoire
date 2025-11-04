extends Control

func _on_start_combat_button_pressed() -> void:
	SignalBus.Start_Combat.emit()

func _on_stop_combat_pressed() -> void:
	SignalBus.Stop_Combat.emit()
	SignalBus.Get_New_Page.emit()
