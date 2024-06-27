extends Control
## UI management

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## Update UI labels
func update_labels(points: int, health: int) -> void:
	$MarginContainer/VBoxContainer/LabelPoints.text = "Points: " + str(points)
	$MarginContainer/VBoxContainer/LabelHealth.text = "Health: " + str(health)


## Update battery amount
func update_battery() -> void:
	pass


## Update a simple texture canvasitem to tell if the robot is listening
func update_listening(listening: bool) -> void:
	if listening:
		$TextureRect.modulate.a = 1
	else:
		$TextureRect.modulate.a = 0
