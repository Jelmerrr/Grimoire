extends Node2D

var destination: Vector2 = Vector2(0, -600) #Needs to be here for targeting shenanigans
var spawnPos : Vector2 = Vector2(0, 150)

var modifierID: int
var modifiers: ModifiersResource
var pageOwner: Node

var pageAlignment: UtilsGlobalEnums.alignment
var pageTags: Array[UtilsGlobalEnums.pageTags]

var buffDuration: int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modifiers = instance_from_id(modifierID)
	SignalBus.PageCasted.connect(countPage)
	SignalBus.Stop_Combat.connect(onCombatEnd)

func countPage(pageType: UtilsGlobalEnums.pageTypes, pageOwnerRef: Node) -> void:
	if pageOwner != null && pageOwnerRef != null:
		if pageOwner == pageOwnerRef:
			pageOwner.Change_Health(5)
			buffDuration -= 1
	#SignalBus.AddPlayerHealth.emit(5)
	if buffDuration == 0:
		queue_free()

func onCombatEnd() -> void:
	queue_free()
