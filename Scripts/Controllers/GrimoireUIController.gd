extends Control

const NEWPAGES_CONTAINER_UI = preload("uid://x6jym32jp0b1")
@onready var pages_showcase: HBoxContainer = $PanelContainer/MarginContainer/PageVBox/PageScrollContainer/MarginContainer/PagesShowcase

var currentPages: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.Add_Page.connect(Add_Page)
	SignalBus.Remove_Page.connect(Remove_Page)
	SignalBus.Start_Combat.connect(highlight)

func Add_Page(Page: PageResource) -> void:
	var instance = NEWPAGES_CONTAINER_UI.instantiate()
	instance.pageResource = Page
	pages_showcase.add_child.call_deferred(instance)

func Remove_Page(pageToRemove: PanelContainer) -> void:
	var pages = pages_showcase.get_children()
	for page in pages:
		if pageToRemove == page:
			page.queue_free()

func highlight() -> void:
	await get_tree().create_timer(UtilsGlobalVariables.PlayerCastSpeed).timeout
	highlight_cycle()

func highlight_cycle() -> void:
	for child in pages_showcase.get_children():
		if UtilsGlobalVariables.inCombat:
			child.Highlight()
			await get_tree().create_timer(UtilsGlobalVariables.PlayerCastSpeed).timeout
		else:
			break
	if UtilsGlobalVariables.inCombat:
		highlight()
