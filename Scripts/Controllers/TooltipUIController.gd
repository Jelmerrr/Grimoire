extends PanelContainer

@onready var tooltip_title: RichTextLabel = $"VBoxContainer/Tooltip Title"
@onready var tooltip_description: RichTextLabel = $"VBoxContainer/Tooltip Description"

var opacity_tween: Tween = null
var tooltipType: String
var offset: Vector2 = Vector2(0,0)

func _ready() -> void:
	modulate.a = 0.0
	global_position = get_global_mouse_position()
	showTooltip(tooltipType)
	SignalBus.HideTooltip.connect(hideTooltip)
	offsetCalc()
	global_position = get_global_mouse_position() + offset

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + offset

#DisplayServer.screen_get_size()
func offsetCalc() -> void:
	var tooltipPos: Vector2i
	tooltipPos = get_global_transform().origin + self.get_minimum_size()
	if get_viewport().get_visible_rect().size.x - tooltipPos.x <= 0:
		offset.x = get_viewport().get_visible_rect().size.x - tooltipPos.x
	elif get_viewport().get_visible_rect().size.y - tooltipPos.y <= 0:
		offset.y = get_viewport().get_visible_rect().size.y - tooltipPos.y

func showTooltip(tooltipTypeRef: String) -> void:
	updateText(tooltipTypeRef)
	modulate.a = 0.0
	tween_opactiy(1.0)

func hideTooltip(tooltipTypeRef: String) -> void:
	modulate.a = 1.0
	await tween_opactiy(0.0)
	queue_free()

func updateText(tooltipTypeRef: String) -> void:
	tooltip_title.text = ""
	tooltip_description.text = ""
	tooltip_title.append_text("[img]" + UtilsGlobalDictionaries.tooltipDict[tooltipTypeRef].Icon + "[/img]")
	tooltip_title.append_text(" " + "[b]" + UtilsGlobalDictionaries.tooltipDict[tooltipTypeRef].Title + "[/b]")
	tooltip_description.append_text(UtilsGlobalDictionaries.tooltipDict[tooltipTypeRef].Description)

func tween_opactiy(to: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, 0.3)
	opacity_tween.set_ease(Tween.EASE_IN_OUT)
	return opacity_tween
