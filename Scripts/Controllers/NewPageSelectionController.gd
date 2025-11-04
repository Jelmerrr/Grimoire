extends Node2D

@onready var new_page_selection_ui: Control = $CanvasLayer/NewPageSelectionUI


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Get_New_Page.connect(process_newPage)
	SignalBus.Selected_New_Page.connect(selected_newPage)

func process_newPage() -> void:
	new_page_selection_ui.visible = true

func selected_newPage() -> void:
	new_page_selection_ui.visible = false
