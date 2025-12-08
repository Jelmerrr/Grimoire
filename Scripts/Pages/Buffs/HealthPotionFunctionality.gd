extends Node2D

var destination: Vector2 = Vector2(0, -600) #Needs to be here for targeting shenanigans
var spawnPos : Vector2 = Vector2(0, 150)

var pageAlignment: UtilsGlobalEnums.alignment
var pageTags: Array[UtilsGlobalEnums.pageTags]

var buffDuration: int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.PageCasted.connect(countPage)
	SignalBus.Stop_Combat.connect(onCombatEnd)

func countPage(pageType: UtilsGlobalEnums.pageTypes) -> void:
	buffDuration -= 1
	SignalBus.AddPlayerHealth.emit(5)
	if buffDuration == 0:
		queue_free()

func onCombatEnd() -> void:
	queue_free()
