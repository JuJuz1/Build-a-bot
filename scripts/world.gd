extends Node3D
## World script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event) -> void:
	# PC Escape
	if event.is_action_pressed("restart"):
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func _on_player_death():
	#await $SpeechToText/CaptureStreamToText/CaptureStreamToText.thread.wait_to_finish()
	#$SpeechToText/CaptureStreamToText.set_deferred("process_mode", PROCESS_MODE_DISABLED)
	#get_tree().reload_current_scene()
	await get_tree().create_timer(4).timeout
	get_tree().quit()
