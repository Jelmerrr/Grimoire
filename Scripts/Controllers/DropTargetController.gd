extends CanvasLayer

var hover_callback: Callable
var drop_callback: Callable

func _can_drop_data(pos: Vector2, data: Variant):
	var can_drop := data is PanelContainer
	if can_drop and hover_callback:
		hover_callback.call(self, data)
	return can_drop

func _drop_data(pos: Vector2, data: Variant):
	if drop_callback:
		drop_callback.call(self, data)
