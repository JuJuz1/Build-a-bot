extends Node
## Node to check if mic works before starting game

@onready var mic_player: AudioStreamPlayer = $MicPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	mic_player.bus = "Record"
	mic_player.play()
