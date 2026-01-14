extends Node2D

@onready var music_channels: Node2D = $MusicChannels
@onready var sfx_channels: Node2D = $SFXChannels

@onready var music_player: AudioStreamPlayer = $MusicChannels/MusicPlayer
const SFX_PLAYER_SCENE = preload("uid://230tx3cvi3dn")
const SFX_INDIVIDUAL_COOLDOWN = 0.1

var rng = RandomNumberGenerator.new()

var fade_tween: Tween = null

var currentState: UtilsGlobalEnums.musicPlayerState

func playMusic() -> void:
	if !music_player.playing:
		music_player.stream = pickMusic(currentState)
		fade_in(music_player)
		music_player.play()

func pickMusic(state: UtilsGlobalEnums.musicPlayerState) -> AudioStream:
	var result: AudioStream
	var stateKey = UtilsGlobalEnums.musicPlayerState.keys()[state]
	var possibleTracks: Array[AudioStream] = []
	
	for track in UtilsGlobalDictionaries.musicLibraryDict[stateKey]:
		possibleTracks.append(UtilsGlobalDictionaries.musicLibraryDict[stateKey][track])
	var rngResult = rng.randi_range(0, possibleTracks.size() -1)
	result = possibleTracks[rngResult]
	
	return result

func playSFX(AudioFile: AudioStreamWAV) -> void:
	#Add a tiny inaudible random delay to offsync multiple calls made on the exact same frame.
	var rngDelay = rng.randf_range(0, 0.01)
	await get_tree().create_timer(rngDelay).timeout
	#This probably breaks at insanely high cast speeds so might need to rebalance that AGAIN.
	
	print("Attempting to play " + str(AudioFile.resource_path))
	var check = true
	for player in sfx_channels.get_children():
		print(player.get_playback_position() + AudioServer.get_time_since_last_mix())
		if player.stream == AudioFile && (player.get_playback_position() + AudioServer.get_time_since_last_mix()) <= SFX_INDIVIDUAL_COOLDOWN:
			print("Too many requests of the same file in rapid succession")
			check = false
	if check == true:
		print("Playing sound")
		var instance = SFX_PLAYER_SCENE.instantiate()
		instance.audioStream = AudioFile
		instance.volume = UtilsGlobalVariables.globalSFXLevel
		sfx_channels.add_child.call_deferred(instance)

func fade_in(audioPlayer: AudioStreamPlayer):
	audioPlayer.volume_db = -100
	volume_tween(audioPlayer, -24, 0.5)

func fade_out(audioPlayer: AudioStreamPlayer):
	audioPlayer.volume_db = -24
	await volume_tween(audioPlayer, -100, 0.5).finished
	audioPlayer.stop()

func volume_tween(audioPlayer: AudioStreamPlayer, to: float, duration: float):
	if fade_tween: fade_tween.kill()
	fade_tween = get_tree().create_tween()
	fade_tween.tween_property(audioPlayer, "volume_db", to, duration)
	fade_tween.set_ease(Tween.EASE_OUT)
	return fade_tween

func _on_music_player_finished() -> void:
	print("music finished")
	await get_tree().create_timer(rng.randi_range(10, 60)).timeout
	playMusic()
