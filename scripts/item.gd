extends RigidBody3D
## Generic item script

signal picked_up

## Constants that are applied to player when picking up an item
@export var health: int
@export var points: int

## Destroy self when colliding with floor
func _on_area_3d_destroy():
	""" 
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.finished.connect(func() -> void: queue_free())
	"""
	queue_free()
	print("destroyed")


## Connect signal and send it to player
func _on_area_3d_item_pickup(body: CharacterBody3D):
	# Not sure if this is good practice (connecting signals in runtime)
	picked_up.connect(body._on_item_picked_up)
	picked_up.emit(self)
	queue_free()
	print("picked up")
