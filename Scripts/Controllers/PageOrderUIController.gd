extends ScrollContainer
@onready var pages_showcase: HBoxContainer = $MarginContainer/PagesShowcase

var selectedPage: PanelContainer
var isHovering: bool

func Sort_Pages(at_position: Vector2, data: Variant) -> void:
	var pages = pages_showcase.get_children()
	var pagesPos: Array[Vector2]
	for item in pages:
		if data == item:
			print(data)
		pagesPos.append(Vector2(item.position.x - scroll_horizontal, item.position.y))
	print(pages)
	print(pages[pagesPos.find(Get_Nearest_Page(at_position, pagesPos))].pageResource.UI_NameString)
	print(data.PageResource)
	#SignalBus.Insert_Page.emit(data.PageResource, pages[pagesPos.find(Get_Nearest_Page(at_position, pagesPos))] -1)

func Get_Nearest_Page(dropPos, pageArray) -> Vector2:
	var closest: Vector2 = pageArray[0]
	for i in pageArray:
		if abs(dropPos - closest) > abs(dropPos - i):
			closest = i
	print("Closest: " + str(closest))
	return closest
