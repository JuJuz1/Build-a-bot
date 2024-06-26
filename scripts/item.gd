extends RigidBody3D
## Generic item script

signal picked_up

#var identifier: String? = null -> _ready()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Identify what item type self is
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


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
	# Not sure if this is a good practice (connecting signals runtime)
	picked_up.connect(body._on_item_picked_up)
	picked_up.emit(self)
	queue_free()
	print("picked up")
