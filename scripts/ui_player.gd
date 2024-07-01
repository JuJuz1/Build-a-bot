extends Control
## UI management

func _ready() -> void:
	$TextureHeal.state_update(false)


## Update UI labels
func update_labels(points: int, health: int) -> void:
	$MarginContainer/VBoxContainer/LabelPoints.text = "Points: " + str(points)
	$MarginContainer/VBoxContainer/LabelHealth.text = "Health: " + str(health)


## Enables time texture when robot gets final model
func enable_time_texture() -> void:
	$TextureTime.state_update(false)
	$TextureTime.show()
	
	$LabelTimeInfo.show()
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($LabelTimeInfo, "modulate:a", 0, 4)


## Function to update a simple texture canvasitem
## [param id, enabled] child's id that is updated, its state
func texture_update(id: int, enabled: bool) -> void:
	get_child(id).state_update(enabled)
