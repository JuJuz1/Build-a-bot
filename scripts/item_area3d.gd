extends Area3D
## Item collision

signal item_pickup
signal destroy

func _on_body_entered(body: PhysicsBody3D):
	if body is Player:
		item_pickup.emit(body)
	else:
		destroy.emit()
