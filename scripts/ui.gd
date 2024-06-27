extends Control
## UI management

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## Update points to UI
func update_points(points: int) -> void:
	$MarginContainer/VBoxContainer/Label.text = "Points: " + str(points)


## Update battery amount
func update_battery() -> void:
	pass


## Update a simple texture canvasitem to tell if the robot is listening
func update_listening(listening: bool) -> void:
	if listening:
		$TextureRect.modulate.a = 1
	else:
		$TextureRect.modulate.a = 0
