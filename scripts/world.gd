extends Node3D
## World script

@onready var music: AudioStreamPlayer = $Music

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(music, "volume_db", -20, 7)


func _input(event) -> void:
	# PC Escape
	if event.is_action_pressed("restart"):
		get_tree().quit()


func _on_player_death() -> void:
	#await $SpeechToText/CaptureStreamToText/CaptureStreamToText.thread.wait_to_finish()
	#$SpeechToText/CaptureStreamToText.set_deferred("process_mode", PROCESS_MODE_DISABLED)
	#get_tree().reload_current_scene()
	await get_tree().create_timer(4).timeout
	get_tree().quit()
