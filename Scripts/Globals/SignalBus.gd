extends Node

signal Add_Page(PageResource)
signal Remove_Page(PanelContainer)
signal Update_Grimoire(updatedGrimoire: Array[PageResource])

signal Start_Combat()
signal Stop_Combat()
signal PageCasted(pageType: UtilsGlobalEnums.pageTypes)
signal CyclePages()

signal Get_New_Page()
signal Selected_New_Page()

signal Ask_EnemyPos()
signal Ask_PlayerPos()

signal ShowTooltip(tooltipType: String)
signal HideTooltip(tooltipType: String)
signal ShowEnemyTooltip(currentHealth: int, maxHealth: int, enemyResource: BaseEnemyResource)

signal Start_Planning_Phase()

signal AddPlayerHealth(value: int)
