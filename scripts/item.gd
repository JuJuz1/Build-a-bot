extends RigidBody3D
## Generic item script

signal picked_up

## Constant gravity when falling
const GRAVITY: float = 0.4

## Export variables make up different items without the need to create different scripts
## Variables that are applied to the player when picking up an item
@export var health: int ## How much health the player will lose or get
@export var points: int ## How many points will be deducted or added
@export var robot_upgrade: bool ## If the item is an upgrade to the robot's model


func _ready():
	gravity_scale = GRAVITY


## Destroy self when colliding with floor
func _on_area_3d_destroy() -> void:
	""" 
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.finished.connect(func() -> void: queue_free())
	"""
	queue_free()
	print("destroyed")


## Connect signal and send it to player
func _on_area_3d_item_pickup(body: CharacterBody3D) -> void:
	# Not sure if this is good practice (connecting signals in runtime)
	picked_up.connect(body._on_item_picked_up)
	picked_up.emit(self)
	queue_free()
	print("picked up")
