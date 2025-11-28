extends Node2D

@onready var music_channels: Node2D = $MusicChannels
@onready var sfx_channels: Node2D = $SFXChannels

@onready var music_player: AudioStreamPlayer = $MusicChannels/MusicPlayer

var fade_tween: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playMusic()

func playMusic() -> void:
	if !music_player.playing:
		fade_in(music_player)
		music_player.play()

func fade_in(audioPlayer: AudioStreamPlayer):
	audioPlayer.volume_db = -100
	volume_tween(audioPlayer, -12, 1)

func fade_out(audioPlayer: AudioStreamPlayer):
	audioPlayer.volume_db = -12
	await volume_tween(audioPlayer, -100, 1).finished
	audioPlayer.stop()

func volume_tween(audioPlayer: AudioStreamPlayer, to: float, duration: float):
	if fade_tween: fade_tween.kill()
	fade_tween = get_tree().create_tween()
	fade_tween.tween_property(audioPlayer, "volume_db", to, duration)
	fade_tween.set_ease(Tween.EASE_OUT)
	return fade_tween
