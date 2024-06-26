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
