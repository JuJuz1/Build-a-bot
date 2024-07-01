extends Node3D
## Menu that runs when the game starts

func _input(event) -> void:
	# PC Escape
	if event.is_action_pressed("restart"):
		get_tree().quit()
	
	# PC Enter, space
	if event.is_action_pressed("start"):
		$LabelInfo.hide()
		$LabelStart.show()
		$AudioCatcher.disable_mic()
		await get_tree().create_timer(2).timeout
		#await $CaptureStreamToText.disable_capture()
		get_tree().change_scene_to_file("res://scenes/world.tscn")
