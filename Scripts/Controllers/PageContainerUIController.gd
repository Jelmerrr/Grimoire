extends PanelContainer

@onready var page_title: Label = $"MarginContainer/VBoxContainer/Page title"
@onready var page_description: Label = $"MarginContainer/VBoxContainer/Page description"

var pageResource: PageResource


var isHovering: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateText()

func UpdateText() -> void:
	if pageResource:
		page_title.text = pageResource.UI_NameString
		page_description.text = pageResource.UI_DescriptionString

func _on_mouse_entered() -> void:
	var stylebox = get_theme_stylebox("panel").duplicate()
	stylebox.border_color = Color("ff8274")
	add_theme_stylebox_override("panel", stylebox)
	isHovering = true

func _on_mouse_exited() -> void:
	var stylebox = get_theme_stylebox("panel").duplicate()
	stylebox.border_color = Color("ff827400")
	add_theme_stylebox_override("panel", stylebox)
	isHovering = false
