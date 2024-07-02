extends Area3D
## Danger that sweeps across the level

signal player_damaged(damage: int)

## Timer that starts the attack
@onready var timer: Timer = $Timer

## Same for the player and itemdropper
const GRID_SIZE: int = 3
## Edge and middle points
const POINTS: Array[int] = [-GRID_SIZE, 0, GRID_SIZE]

## How much damage the danger will inflict
const DAMAGE: int = 10

func _ready() -> void:
	timer.timeout.connect(attack)
	timer.start(20)


## Danger attack
func attack() -> void:
	var tween: Tween = create_tween()
	# If danger is left (x < 0) -> goes right, if right -> goes left
	tween.tween_property(self, "position:x", -position.x, 4)
	# Move to a random "height"
	position.z = POINTS.pick_random()
	timer.start(randi_range(15, 20))


## When hitting player only (should be)
func _on_body_entered(body: PhysicsBody3D):
	if body is Player:
		player_damaged.emit(DAMAGE)
