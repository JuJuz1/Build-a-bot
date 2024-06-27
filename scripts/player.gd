extends CharacterBody3D
class_name Player
## Player character

## Used to limit how many actions the player can perform in a time limit
var action_available: bool = true
const TIME_FOR_ACTION: float = 1.0
@onready var timer_action: Timer = $Timer

## Size for the grid (one tile), how much the player will move with each movement action
const GRID_SIZE: float = 3

## Current point count and health
var points: int = 0
var health: int = 30

func _ready() -> void:
	$UI.update_labels(points, health)
	timer_action.wait_time = TIME_FOR_ACTION
	timer_action.timeout.connect(enable_action)


## Enable action to control player
func enable_action() -> void:
	action_available = true
	$UI.update_listening(action_available)
	print(action_available)


## When picking up item
func _on_item_picked_up(item: RigidBody3D) -> void:
	health += item.health
	points += item.points
	$UI.update_labels(points, health)


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
		# Presume to make an action
		var action_made: bool = true
		# If making a special action (time or heal), then don't consume battery
		var action_is_special: bool = false
		# Cooldown for next action
		var action_time: int = 1
		print(position)
		# TODO: Animationplayer for all the actions
		if text.contains("time"):
			# Slow down the dropping items
			#signal.time.emit() to world.gd
			action_is_special = true
			print("time")
		# Tiny model couldn't recognise this one very well
		elif text.contains("heal") or text.contains("heel"):
			# Start a timer to heal the bot (recharge battery)
			
			# Healing increases the amount of time to make the next action
			action_time = 3
			action_is_special = true
			print("heal")
		elif text.contains("left"):
			# Check for position to stay in the 3x3 grid
			if position.x == -GRID_SIZE:
				return
			#position -= Vector3(GRID_SIZE, 0, 0)
			# Create a tween to tween position
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position:x", position.x - GRID_SIZE, 0.3)
		elif text.contains("right"):
			if position.x == GRID_SIZE:
				return
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position:x", position.x + GRID_SIZE, 0.3)
		elif text.contains("up"):
			if position.z == -GRID_SIZE:
				return
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position:z", position.z - GRID_SIZE, 0.3)
		elif text.contains("down"):
			if position.z == GRID_SIZE:
				return
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position:z", position.z + GRID_SIZE, 0.3)
		else: # Only if the player doesn't make any action
			action_made = false
	
		if action_made:
			if not action_is_special:
				health -= 1
				if health <= 0:
					#healing_start()
					queue_free()
			# Restart action timer to prevent making actions too fast
			action_available = false
			$UI.update_listening(action_available)
			$UI.update_labels(points, health)
			# If healed action_time == 3 else 1
			timer_action.start(action_time)
	
