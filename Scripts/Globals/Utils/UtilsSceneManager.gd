extends Node

const BOARD_SCENE = preload("uid://bdx3eg3w0wwmw")
const TITLE_SCREEN_SCENE = preload("uid://vl7uj8cdqhru")

var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(res_path):
	call_deferred("deferred_switch_scene", res_path)

func deferred_switch_scene(res_path):
	SceneTransitionControllerScene.transition("Fade_Out")
	await SceneTransitionControllerScene.animation_player.animation_finished
	current_scene.free()
	var s = res_path
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	SceneTransitionControllerScene.transition("Fade_In")
