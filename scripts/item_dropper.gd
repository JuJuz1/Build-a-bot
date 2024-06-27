extends Area3D
## Item dropper

@onready var item = preload("res://scenes/item.tscn")
@onready var timer_item_drop = $Timer

## Same for the player
const GRID_SIZE: int = 3
## Edge and middle points
const POINTS: Array[int] = [-GRID_SIZE, 0, GRID_SIZE]

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_item_drop.timeout.connect(drop_item)
	await get_tree().create_timer(5).timeout
	timer_item_drop.start()


## Instantiate the item and add it as a child to the tree
func drop_item() -> void:
	var item_instance = item.instantiate()
	# Pick 2 random values from POINTS array (3^2 = 9 possibilities) and assign to position
	item_instance.position = Vector3(POINTS.pick_random(), position.y, POINTS.pick_random())
	get_tree().root.add_child(item_instance)
	
	timer_item_drop.start(randf_range(0.5, 2))
