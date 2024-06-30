extends Area3D
## Item dropper

## Preload all different items
@onready var Item = preload("res://scenes/item.tscn")
@onready var Poison = preload("res://scenes/poison.tscn")
@onready var Robot_upgrade = preload("res://scenes/robot_upgrade.tscn")

@onready var timer_item_drop = $Timer

## All items that could be generated to the level
var items: Array[PackedScene]

## Same for the player
const GRID_SIZE: int = 3
## Edge and middle points
const POINTS: Array[int] = [-GRID_SIZE, 0, GRID_SIZE]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Append preloaded items
	items.append(Item)
	items.append(Poison)
	items.append(Robot_upgrade)
	
	timer_item_drop.timeout.connect(drop_item)
	await get_tree().create_timer(2).timeout
	timer_item_drop.start()


## Instantiate the item and add it as a child to the tree
func drop_item() -> void:
	var item_instance = items.pick_random().instantiate()
	# Pick 2 random values from POINTS array (3^2 = 9 possibilities) and assign to position
	item_instance.position = Vector3(POINTS.pick_random(), position.y, POINTS.pick_random())
	get_tree().root.add_child(item_instance)
	
	timer_item_drop.start(randf_range(0.5, 2))
