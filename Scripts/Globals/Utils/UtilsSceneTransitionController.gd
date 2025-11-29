extends Control

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

func transition(animation: String) -> void:
	animation_player.play(animation)
