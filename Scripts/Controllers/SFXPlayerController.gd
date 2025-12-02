extends AudioStreamPlayer

var audioStream: AudioStreamWAV
var volume: float

func _ready() -> void:
	stream = audioStream
	volume_db = volume
	self.play()

func _on_finished() -> void:
	queue_free()
