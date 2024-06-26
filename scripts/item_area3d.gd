extends Area3D
## Item collision

signal item_pickup
signal destroy

func _on_body_entered(body):
	if body is Player:
		item_pickup.emit()
	else:
		destroy.emit()
