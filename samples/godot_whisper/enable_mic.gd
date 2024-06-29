extends CheckBox

@onready var audio_player: AudioStreamPlayer = $"../../AudioPlayer"
@onready var mic_player: AudioStreamPlayer = $"../../MicPlayer"
@onready var mic_label: Label = $"../Label"

func _ready():
	if ProjectSettings.get("audio/driver/enable_input"):
		mic_label.text = ""
	await get_tree().create_timer(0.5).timeout
	toggled.emit(true)

func _on_toggled(toggled_on: bool):
	if toggled_on:
		mic_player.play()
		audio_player.stop()
	else:
		mic_player.stop()
		audio_player.play()
