extends PanelContainer

@onready var hp_bar: ProgressBar = $VBoxContainer/HpBar

@onready var hp_bar_label: RichTextLabel = $VBoxContainer/HpBar/HpBarLabel
@onready var enemy_name_label: RichTextLabel = $VBoxContainer/EnemyNameLabel

@onready var page_container: Control = $VBoxContainer/PageContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	page_container.interactable = false


func update_details(currentHealth: int, enemyResource: BaseEnemyResource) -> void:
	enemy_name_label.text = enemyResource.enemyName
	hp_bar_label.text = str(currentHealth) + " / " + str(enemyResource.maxHealth)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
