extends PanelContainer

@onready var hp_bar: ProgressBar = $VBoxContainer/HpBar

@onready var hp_bar_label: RichTextLabel = $VBoxContainer/HpBar/HpBarLabel
@onready var enemy_name_label: RichTextLabel = $VBoxContainer/EnemyNameLabel
@onready var page_showcase: HBoxContainer = $VBoxContainer/ScrollContainer/PageShowcase

var opacity_tween: Tween = null

const NEWPAGES_CONTAINER_UI = preload("uid://x6jym32jp0b1")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0.0
	SignalBus.ShowEnemyTooltip.connect(show_tooltip)

func show_tooltip(currentHealth: int, maxHealth: int, enemyResource: BaseEnemyResource) -> void:
	for page in page_showcase.get_children():
		page.queue_free()
	update_details(currentHealth, maxHealth, enemyResource)
	modulate.a = 0.0
	tween_opactiy(1.0)

func hide_tooltip() -> void:
	modulate.a = 1.0
	await tween_opactiy(0.0)

func update_details(currentHealth: int, maxHealth: int, enemyResource: BaseEnemyResource) -> void:
	enemy_name_label.text = enemyResource.enemyName
	hp_bar_label.text = str(currentHealth) + " / " + str(maxHealth)
	for page in enemyResource.enemyGrimoire.Pages:
		Add_Enemy_Page(page)

func Add_Enemy_Page(Page: PageResource) -> void:
	var instance = NEWPAGES_CONTAINER_UI.instantiate()
	instance.pageResource = Page
	instance.interactable = false
	page_showcase.add_child.call_deferred(instance)

func tween_opactiy(to: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, 0.3)
	opacity_tween.set_ease(Tween.EASE_IN_OUT)
	return opacity_tween
