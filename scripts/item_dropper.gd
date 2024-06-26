extends Area3D
## Item dropper

@onready var item = preload("res://scenes/item.tscn")
@onready var timer_item_drop = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_item_drop.timeout.connect(drop_item)
	await get_tree().create_timer(5).timeout
	timer_item_drop.start()


## Instantiate the item and add it as a child to the tree
func drop_item() -> void:
	var item_instance = item.instantiate()
	item_instance.position = Vector3(randi_range(-1, 1), 5, randi_range(-1, 1))
	get_tree().root.add_child(item_instance)
	timer_item_drop.start(randf_range(0.5, 2))
