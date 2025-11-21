extends Node2D

var destination: Vector2 = Vector2(0, -600)
var spawnPos : Vector2 = Vector2(0, 150)
var damage : int = 15
@onready var area_2d: Area2D = $Area2D

var pageAlignment: UtilsGlobalEnums.alignment

var pageTags: Array[UtilsGlobalEnums.pageTags]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.position = destination
	SignalBus.Stop_Combat.connect(onCombatEnd)
	if pageAlignment == UtilsGlobalEnums.alignment.Player:
		area_2d.set_collision_layer_value(2, true)
	elif pageAlignment == UtilsGlobalEnums.alignment.Enemy:
		area_2d.set_collision_layer_value(4, true)

func _draw() -> void:
	draw_polyline(get_points(), Color("bac7c7"), 8.0, false)

func _on_life_timer_timeout() -> void:
	queue_free()

func onCombatEnd() -> void:
	queue_free()

func get_points() -> Array[Vector2]:
	var points: Array[Vector2]
	var rng = RandomNumberGenerator.new()
	points.append(spawnPos)
	for i:float in range(9):
		var frame: float =  ((i + 1) / 10)
		var interpolation = spawnPos.lerp(destination, frame)
		interpolation = Vector2(interpolation.x + rng.randf_range(-40, 40), interpolation.y + rng.randf_range(-40, 40),)
		points.append(interpolation)
	points.append(destination)
	return points

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.Get_Damaged(self)
