extends Area3D
## Item dropper

## Preload all different items
const ITEM = preload("res://scenes/items/item.tscn")
const POISON = preload("res://scenes/items/poison.tscn")
const BATTERY = preload("res://scenes/items/battery.tscn")
const ROBOT_UPGRADE_0 = preload("res://scenes/items/robot_upgrade_0.tscn")
const ROBOT_UPGRADE_1 = preload("res://scenes/items/robot_upgrade_1.tscn")
const ROBOT_UPGRADE_2 = preload("res://scenes/items/robot_upgrade_2.tscn")

@onready var timer_item_drop = $Timer

## All items that could be generated to the level
var items: Array[PackedScene]

## When player slows down the time and difficulty increase
var time_slow: bool = false
var difficulty_increased: bool = false
## Applied to items when difficulty is increased
const GRAVITY_DIFFICULTY: float = 0.6

## Same for the player
const GRID_SIZE: int = 3
## Edge and middle points
const POINTS: Array[int] = [-GRID_SIZE, 0, GRID_SIZE]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Append preloaded items
	items.append(ITEM)
	items.append(POISON)
	items.append(BATTERY)
	items.append(ROBOT_UPGRADE_0)
	items.append(ROBOT_UPGRADE_1)
	items.append(ROBOT_UPGRADE_2)
	
	timer_item_drop.timeout.connect(drop_item)
	await get_tree().create_timer(2).timeout
	timer_item_drop.start()


## Increase difficulty when certain points gap is reached
## Done by increasing the amount of hazardous items that can be dropped
func _on_player_point_gap_reached():
	if difficulty_increased:
		return
	difficulty_increased = true
	await get_tree().create_timer(1).timeout
	items.append(POISON)
	items.append(POISON)


## When player slows down the time
## [param enabled] current state
func _on_player_time(enabled: bool) -> void:
	time_slow = enabled


## Instantiate the item and add it as a child to the tree
func drop_item() -> void:
	var item_instance = items.pick_random().instantiate()
	# Pick 2 random values from POINTS array (3^2 = 9 possibilities) and assign to position
	item_instance.position = Vector3(POINTS.pick_random(), position.y, POINTS.pick_random())
	get_tree().root.add_child(item_instance)
	if difficulty_increased:
		item_instance.change_gravity(GRAVITY_DIFFICULTY)
	if time_slow:
		item_instance.change_gravity()
	
	timer_item_drop.start(randf_range(0.75, 2))
