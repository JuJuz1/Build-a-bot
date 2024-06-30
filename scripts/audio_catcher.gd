extends Node
## Node to check if mic works before starting game

@onready var mic_player: AudioStreamPlayer = $MicPlayer
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mic_player.bus = "Record"
	mic_player.play()


## Disable mic and hide UI when starting game
func disable_mic() -> void:
	mic_player.stop()
	$CheckBox.hide()
	label.hide()


## Function to respond to button signal and its state
## [param toggled_on] button's state
func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		mic_player.play()
		label.text = "On"
	else:
		mic_player.stop()
		label.text = "Off"
