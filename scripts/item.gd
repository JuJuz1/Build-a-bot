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


## Destroy self
func _on_area_3d_destroy():
	""" 
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.finished.connect(func() -> void: queue_free())
	"""
	queue_free()


## Send signal to player
func _on_area_3d_item_pickup():
	picked_up.emit(self)
