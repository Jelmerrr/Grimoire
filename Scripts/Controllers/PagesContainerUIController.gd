extends Control

var dragging_node = null
var dragging_panel = null
var drag_offset = 0.0
var threshold = 140

var interactable = true

@onready var page_title: RichTextLabel = $"CanvasGroup/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/Page title"
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
		page_title.text = "[b]" + pageResource.UI_NameString + "[/b]"
		page_description.text = pageResource.UI_DescriptionString

func _on_gui_input(event: InputEvent) -> void:
	if !UtilsGlobalVariables.inCombat && interactable:
		if event.is_action_pressed("click"):
			#Create a temporary node that can move freely.
			dragging_node = self.duplicate()
			dragging_node.set_script(null)
			dragging_node.name = "DuplicatePage"
			vbox.get_parent().add_child(dragging_node)
			set_process_input(true)
			#Initial node positioning.
			drag_offset = get_global_mouse_position().x - global_position.x + scrollContainer.global_position.x
			dragging_node.position.x = get_global_mouse_position().x - drag_offset + scrollContainer.scroll_horizontal
			dragging_panel = dragging_node.get_node("CanvasGroup").get_node("PanelContainer") #PanelContainer
			dragging_panel.position.x = dragging_node.position.x
			
			#Temporarily hide the "real" panel.
			panel.hide()
			#set_process_input(true)
			#get_tree().paused = true

func _input(event):
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		#Update panel positioning according to mouse movement.
		dragging_panel.position.x = 0 #Reset position offset when mouse inputs are detected
		dragging_node.position.x = get_global_mouse_position().x - drag_offset + scrollContainer.scroll_horizontal
		dragging_panel.size = Vector2(140,180)
		
		#Handle ordering within the scroll container.
		if dragging_node.global_position.x < global_position.x - threshold: #dragging up past threshold
			if self.get_index() > 0:
				vbox.move_child(self, self.get_index() -1)
		elif dragging_node.global_position.x > global_position.x + threshold: #dragging up past threshold
			if self.get_index() < vbox.get_child_count() -1:
				vbox.move_child(self, self.get_index() +1)
	
	#Once dragging input is released.
	if event.is_action_released("click"):
		#Reveal original panel and remove the temporary node.
		panel.show()
		dragging_node.queue_free()
		set_process_input(false)
		
		#Update grimoire page ordering.
		var newpages = vbox.get_children()
		var newgrimoire: Array[PageResource]
		for page in newpages:
			newgrimoire.append(page.pageResource)
		SignalBus.Update_Grimoire.emit(newgrimoire)

func Highlight() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_method(Set_Shader_ColorParam, Color("bac7c7"), Color("150e10"), 0.5)
	tween.tween_method(Set_shader_WidthParam, 5.0, 0.0, 0.5)

func Set_Shader_ColorParam(value: Color):
	canvas_group.material.set_shader_parameter("color", value)

func Set_shader_WidthParam(value: float):
	canvas_group.material.set_shader_parameter("width", value)

func _on_page_description_meta_hover_started(meta: Variant) -> void:
	SignalBus.ShowTooltip.emit(meta)

func _on_page_description_meta_hover_ended(meta: Variant) -> void:
	SignalBus.HideTooltip.emit(meta)
