extends Control

var dragging_node = null
var drag_offset = 0.0
var threshold = 200

@onready var page_title: RichTextLabel = $"CanvasGroup/PanelContainer/MarginContainer/VBoxContainer/Page title"
@onready var page_description: RichTextLabel = $"CanvasGroup/PanelContainer/MarginContainer/VBoxContainer/Page description"
@onready var canvas_group: CanvasGroup = $CanvasGroup

var pageResource: PageResource

@onready var panel = $CanvasGroup/PanelContainer
@onready var vbox = get_parent()
var marginContainer
var scrollContainer

func _ready():
	set_process_input(false)
	UpdateText()
	marginContainer = vbox.get_parent()
	scrollContainer = marginContainer.get_parent()

func UpdateText() -> void:
	if pageResource:
		page_title.text = pageResource.UI_NameString
		page_description.text = pageResource.UI_DescriptionString

func _on_gui_input(event: InputEvent) -> void:
	if !UtilsGlobalVariables.inCombat:
		if event.is_action_pressed("click"):
			dragging_node = self.duplicate()
			#dragging_node.disconnect("gui_input", dragging_node, "_on_Control_gui_input")
			dragging_node.set_script(null)
			vbox.get_parent().add_child(dragging_node)
			dragging_node.position = global_position
			drag_offset = get_global_mouse_position().x - global_position.x + scrollContainer.global_position.x
			#var new_style = panel.get_stylebox("panel").duplicate()
			#new_style.shadow_color.a = 0.3
			#new_style.shadow_size = 8
			#new_style.shadow_offset = Vector2(3,3)
			var dragging_panel = dragging_node.get_node("CanvasGroup").get_node("PanelContainer") #PanelContainer
			#dragging_panel.add_stylebox_override("panel", new_style)
			dragging_panel.position.x = -4
			panel.hide()
			set_process_input(true)

func _input(event):
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		dragging_node.position.x = get_global_mouse_position().x - drag_offset + scrollContainer.scroll_horizontal
		if dragging_node.global_position.x < global_position.x - threshold: #dragging up past threshold
			if self.get_index() > 0:
				vbox.move_child(self, self.get_index() -1)
		elif dragging_node.global_position.x > global_position.x + threshold: #dragging up past threshold
			if self.get_index() < vbox.get_child_count() -1:
				vbox.move_child(self, self.get_index() +1)
	if event.is_action_released("click"):
		panel.show()
		dragging_node.queue_free()
		set_process_input(false)
		var newpages = vbox.get_children()
		var newgrimoire: Array[PageResource]
		for page in newpages:
			newgrimoire.append(page.pageResource)
		SignalBus.Update_Grimoire.emit(newgrimoire)

func Highlight() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_method(Set_Shader_ColorParam, Color("d9ffe2"), Color("041b38"), 0.5)
	tween.tween_method(Set_shader_WidthParam, 5.0, 0.0, 0.5)

func Set_Shader_ColorParam(value: Color):
	canvas_group.material.set_shader_parameter("color", value)

func Set_shader_WidthParam(value: float):
	canvas_group.material.set_shader_parameter("width", value)

func _on_page_description_meta_hover_started(meta: Variant) -> void:
	print(meta)
