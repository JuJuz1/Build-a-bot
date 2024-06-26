extends CharacterBody3D
class_name Player
## Player character

## Used to limit how many actions the player can perform in a time limit
var action_available: bool = true
const TIME_FOR_ACTION: float = 1.0
@onready var timer_action: Timer = $Timer

## Size for the grid, how much the player will move with each movement action
const GRID_SIZE: int = 1

## Current points
var points: int = 0

func _ready() -> void:
	timer_action.wait_time = TIME_FOR_ACTION
	timer_action.timeout.connect(enable_action)


## Enable action to control player
func enable_action() -> void:
	action_available = true
	print(action_available)


## When picking up item
func _on_item_picked_up(item: RigidBody3D) -> void:
	points += 5
	$UI.update_points(points)
	print(item)


## Performing player character actions based on the transcribed speech to text
func _on_capture_stream_to_text_updated_player(text : String) -> void:
	# Parsing and modifying the text not needed atm
	# Everything to lower case
	text = text.to_lower()
	print(text)
	
	#if not action_available or text.is_empty():
		#return
	# Remove first space
	#text = text.substr(1, text.length())
	# Find the first index of a space
	#var index: int = text.findn(" ")
	# Take the first word, if index is -1, returns the original string back
	# This happens only if text has 1 word
	#text = text.substr(0, index)
	if action_available:
		var action_made: bool = false
		# Healing increases the amount of time to make the next action
		var action_time: int = 1
		print(position)
		# TODO: Animationplayer for all the actions
		if text.contains("time"):
			# Slow down the dropping items
			#signal.time.emit() to world.gd
			print("time")
			action_made = true
		elif text.contains("heal") or text.contains("heel"):
			# Start a timer to heal the bot (recharge battery)
			print("heal")
			action_time = 3
			action_made = true
		elif text.contains("left"):
			# Check for position to stay in the 3x3 grid
			if position.x == -GRID_SIZE:
				return
			position -= Vector3(GRID_SIZE, 0, 0)
			action_made = true
		elif text.contains("right"):
			if position.x == GRID_SIZE:
				return
			position += Vector3(GRID_SIZE, 0, 0)
			action_made = true
		elif text.contains("up"):
			if position.z == -GRID_SIZE:
				return
			position -= Vector3(0, 0, GRID_SIZE)
			action_made = true
		elif text.contains("down"):
			if position.z == GRID_SIZE:
				return
			position += Vector3(0, 0, GRID_SIZE)
			action_made = true
	
		if action_made:
			# Restart action timer to prevent making actions too fast
			action_available = false
			# If healed action_time == 3 else 1
			timer_action.start(action_time)
	
