extends Node3D
## Menu that runs when the game starts

func _input(event):
	# PC Enter, space
	if event.is_action_pressed("start"):
		$LabelInfo.hide()
		$LabelStart.show()
		await get_tree().create_timer(2).timeout
		#await $CaptureStreamToText.disable_capture()
		get_tree().change_scene_to_file("res://scenes/world.tscn")
