extends Node

var grim: GrimoireResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grim = GrimoireResource.new()
	grim.CastSpeed = 1.0
	UtilsGlobalVariables.BasePlayerCastSpeed = grim.CastSpeed
	SignalBus.Add_Page.connect(Add_Page)
	SignalBus.Remove_Page.connect(Remove_Page)
	SignalBus.Start_Combat.connect(Start_Combat)
	SignalBus.Stop_Combat.connect(Stop_Combat)
	SignalBus.Update_Grimoire.connect(Update_Grimoire)
	SignalBus.Add_Page.emit(preload("uid://bmvokbotxdoyw"))
	SignalBus.Add_Page.emit(preload("uid://fsehssw35cdq"))

func Add_Page(Page: PageResource) -> void:
	grim.Pages.append(Page)

func Remove_Page(location: int) -> void:
	grim.Pages.remove_at(location)

func Cast_Page(Page: PageResource) -> void:
	SignalBus.Ask_EnemyPos.emit()
	if UtilsGlobalVariables.enemyPositions.size() != 0:
		if Page.PageScene != null:
			var instance = Page.PageScene.instantiate()
			instance.destination = Targeting_Logic(Page.PageTargeting)
			instance.pageAlignment = UtilsGlobalEnums.alignment.Player
			SignalBus.PageCasted.emit(Page.PageType)
			add_child.call_deferred(instance)
	elif UtilsGlobalVariables.enemyPositions.size() == 0:
		SignalBus.Stop_Combat.emit()
		SignalBus.Get_New_Page.emit()
		UtilsGlobalVariables.currentGameState = UtilsGlobalEnums.gameState.Rewarding
	if Page.PageType == UtilsGlobalEnums.pageTypes.Spell:
		UtilsGlobalVariables.SpellPagesCastInCycleCount += 1

func Targeting_Logic(targetType: UtilsGlobalEnums.pageTargeting) -> Vector2:
	SignalBus.Ask_EnemyPos.emit()
	var positions: Array[Vector2] = UtilsGlobalVariables.enemyPositions
	var result: Vector2
	
	if positions.size() != 0:
		if targetType == UtilsGlobalEnums.pageTargeting.Closest:
			var closest_pos: Vector2
			var closest_distance = INF
			for pos in positions:
				var distance = Vector2(0, 150).distance_to(pos)
				if distance < closest_distance:
					closest_distance = distance
					closest_pos = pos
			result = closest_pos
			return result
		
		elif targetType == UtilsGlobalEnums.pageTargeting.Random:
			result = positions[UtilsRngHandler.rng.randi_range(0, positions.size() - 1)]
			return result
		
		elif targetType == UtilsGlobalEnums.pageTargeting.None:
			result = Vector2(0, -600)
			return result
	
	result = Vector2(0, -600)
	return result

func Cycle_Pages() -> void:
	for item in grim.Pages:
		if UtilsGlobalVariables.inCombat:
			Cast_Page(item)
			await get_tree().create_timer(UtilsGlobalVariables.PlayerCastSpeed).timeout
		else:
			break
	if UtilsGlobalVariables.inCombat:
		Restart_Cycle()

func Restart_Cycle() -> void:
	await get_tree().create_timer(UtilsGlobalVariables.PlayerCastSpeed).timeout
	SignalBus.CyclePages.emit()
	UtilsGlobalVariables.SpellPagesCastInCycleCount = 0
	Cycle_Pages()

func Start_Combat() -> void:
	if !UtilsGlobalVariables.inCombat:
		UtilsGlobalVariables.inCombat = true
		Restart_Cycle()
		UtilsGlobalVariables.currentEnemyLevel = UtilsGlobalVariables.currentEnemyLevel + 1

func Stop_Combat() -> void:
	if UtilsGlobalVariables.inCombat:
		UtilsGlobalVariables.inCombat = false

func Update_Grimoire(updatedGrimoire: Array[PageResource]):
	grim.Pages.clear()
	for page in updatedGrimoire:
		grim.Pages.append(page)
