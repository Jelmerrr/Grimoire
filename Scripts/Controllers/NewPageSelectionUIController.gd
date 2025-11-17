extends Control

@onready var page_1_title: RichTextLabel = $"HBoxPanels/New Page 1 Container/MarginContainer/VBoxContainer/Page 1 Title"
@onready var page_1_description: RichTextLabel = $"HBoxPanels/New Page 1 Container/MarginContainer/VBoxContainer/Page 1 Description"
@onready var page_2_title: RichTextLabel = $"HBoxPanels/New Page 2 Container/MarginContainer/VBoxContainer/Page 2 Title"
@onready var page_2_description: RichTextLabel = $"HBoxPanels/New Page 2 Container/MarginContainer/VBoxContainer/Page 2 Description"
@onready var page_3_title: RichTextLabel = $"HBoxPanels/New Page 3 Container/MarginContainer/VBoxContainer/Page 3 Title"
@onready var page_3_description: RichTextLabel = $"HBoxPanels/New Page 3 Container/MarginContainer/VBoxContainer/Page 3 Description"
@onready var new_page_1_container: PanelContainer = $"HBoxPanels/New Page 1 Container"
@onready var new_page_2_container: PanelContainer = $"HBoxPanels/New Page 2 Container"
@onready var new_page_3_container: PanelContainer = $"HBoxPanels/New Page 3 Container"

var page1selected: bool = false
var page2selected: bool = false
var page3selected: bool = false

var page1resource: PageResource
var page2resource: PageResource
var page3resource: PageResource

var available_pages: Array[PageResource] = []
var size_tween: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SignalBus.Stop_Combat.connect(initialize_pages)
	SignalBus.Get_New_Page.connect(initialize_pages)
	new_page_1_container.pivot_offset = new_page_1_container.size / 2
	new_page_2_container.pivot_offset = new_page_2_container.size / 2
	new_page_3_container.pivot_offset = new_page_3_container.size / 2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if page1selected:
				SignalBus.Selected_New_Page.emit()
				SignalBus.Add_Page.emit(page1resource)
			elif page2selected:
				SignalBus.Selected_New_Page.emit()
				SignalBus.Add_Page.emit(page2resource)
			elif page3selected:
				SignalBus.Selected_New_Page.emit()
				SignalBus.Add_Page.emit(page3resource)

func initialize_pages() -> void:
	load_pages()
	generate_page1()
	generate_page2()
	generate_page3()

func load_pages() -> void:
	available_pages.clear()
	for file in DirAccess.get_files_at("res://Resources/Pages/Page Resources/"):
		available_pages.append(ResourceLoader.load("res://Resources/Pages/Page Resources/"+file))

func select_page() -> PageResource:
	var totalWeight: int = 0
	var pageResult: PageResource
	var pageCount: int = 0
	for page in available_pages:
		totalWeight += page.TailoredWeighting #Get total weight of all pages
	var rngResult = UtilsRngHandler.rng.randi_range(1, totalWeight) #Pick result
	for page in available_pages: #Cycles between each page
		rngResult -= page.TailoredWeighting #Subtracting the page's weighting from the result
		if rngResult <= 0 || rngResult == 0: #Once we reach 0 or lower
			pageResult = page #The page will be picked
			break #End de for loop early once page is picked
		pageCount += 1 #Incremental counter to keep track of which page is selected
	available_pages.remove_at(pageCount) #Remove selected page to avoid duplicates
	return pageResult

func generate_page1() -> void:
	var selected_page = select_page()
	page1resource = selected_page
	page_1_title.text = selected_page.UI_NameString
	page_1_description.text = selected_page.UI_DescriptionString

func generate_page2() -> void:
	var selected_page = select_page()
	page2resource = selected_page
	page_2_title.text = selected_page.UI_NameString
	page_2_description.text = selected_page.UI_DescriptionString

func generate_page3() -> void:
	var selected_page = select_page()
	page3resource = selected_page
	page_3_title.text = selected_page.UI_NameString
	page_3_description.text = selected_page.UI_DescriptionString

func _on_new_page_1_container_mouse_entered() -> void:
	#new_page_1_container.scale = Vector2(1.2, 1.2)
	SizeTween(Vector2(1.1,1.1), new_page_1_container)
	page1selected = true

func _on_new_page_1_container_mouse_exited() -> void:
	#new_page_1_container.scale = Vector2(1.0, 1.0)
	SizeTween(Vector2(1.0,1.0), new_page_1_container)
	page1selected = false

func _on_new_page_2_container_mouse_entered() -> void:
	#new_page_2_container.scale = Vector2(1.2, 1.2)
	SizeTween(Vector2(1.1,1.1), new_page_2_container)
	page2selected = true

func _on_new_page_2_container_mouse_exited() -> void:
	#new_page_2_container.scale = Vector2(1.0, 1.0)
	SizeTween(Vector2(1.0,1.0), new_page_2_container)
	page2selected = false

func _on_new_page_3_container_mouse_entered() -> void:
	#new_page_3_container.scale = Vector2(1.2, 1.2)
	SizeTween(Vector2(1.1,1.1), new_page_3_container)
	page3selected = true

func _on_new_page_3_container_mouse_exited() -> void:
	#new_page_3_container.scale = Vector2(1.0, 1.0)
	SizeTween(Vector2(1.0,1.0), new_page_3_container)
	page3selected = false


func SizeTween(to: Vector2, container: PanelContainer):
	#if size_tween: size_tween.kill()
	size_tween = get_tree().create_tween()
	size_tween.set_ease(Tween.EASE_IN_OUT)
	size_tween.set_trans(Tween.TRANS_ELASTIC)
	size_tween.tween_property(container, "scale", to, 0.3)
	return size_tween

func _on_page_1_description_meta_hover_ended(meta: Variant) -> void:
	SignalBus.HideTooltip.emit(meta)

func _on_page_1_description_meta_hover_started(meta: Variant) -> void:
	SignalBus.ShowTooltip.emit(meta)

func _on_page_2_description_meta_hover_ended(meta: Variant) -> void:
		SignalBus.HideTooltip.emit(meta)

func _on_page_2_description_meta_hover_started(meta: Variant) -> void:
	SignalBus.ShowTooltip.emit(meta)

func _on_page_3_description_meta_hover_ended(meta: Variant) -> void:
	SignalBus.HideTooltip.emit(meta)

func _on_page_3_description_meta_hover_started(meta: Variant) -> void:
	SignalBus.ShowTooltip.emit(meta)
