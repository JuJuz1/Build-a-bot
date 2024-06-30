extends CharacterBody3D
class_name Player
## Player character

## Signals
signal death ## Emitted to world on death
signal action(action_id: int) ## Emitted to world/UI to flash labels on screen

## Used to limit how many actions the player can perform in a time limit
var action_available: bool = true
const TIME_FOR_ACTION: float = 1.0
@onready var timer_action: Timer = $TimerAction

## Time it takes to start healing, cycle length (same) and healing amount
const TIME_FOR_HEAL: float = 2.0
const HEAL_AMOUNT: int = 1
@onready var timer_healing: Timer = $TimerHealing

## Size for the grid (one tile), how much the player will move with each movement action
const GRID_SIZE: float = 3

## Current point count and health
var points: int = 0
var health: int = 30

## Points to tell when the robot will be upgraded (how many are needed till the next)
var upgrade_points: int = 3
var model_current: int = 0

## Robot's models
const ROBOT_MODEL_0: PackedScene = preload("res://graphics/blender/robot_model_0.blend")
const ROBOT_MODEL_1: PackedScene = preload("res://graphics/blender/robot_model_1.blend")
## Dictionary to hold all the upgrade models with the corresponding stage of the robot
var dict_models: Dictionary = {0: ROBOT_MODEL_0, 1: ROBOT_MODEL_1}

func _ready() -> void:
	$UI.update_labels(points, health)
	timer_action.wait_time = TIME_FOR_ACTION
	timer_action.timeout.connect(action_enable)
	
	timer_healing.wait_time = TIME_FOR_HEAL
	timer_healing.timeout.connect(heal)
	
	#health = 0
	# TODO: comment out
	upgrade_points = 1


## Enable action to control player
func action_enable() -> void:
	action_available = true
	$UI.update_listening(action_available)


## Increase health when healing
func heal() -> void:
	health += HEAL_AMOUNT
	print("healing")
	$UI.update_labels(points, health)


## When picking up item
func _on_item_picked_up(item: RigidBody3D) -> void:
	health += item.health
	points += item.points
	if points < 0:
		points = 0
	$UI.update_labels(points, health)
	if health <= 0:
		#queue_free()
		death.emit()
		$UI/Quit.show()
	if item.robot_upgrade:
		upgrade_points -= 1
		if upgrade_points <= 0:
			upgrade()


## Upgrades the robot's model
func upgrade() -> void:
	upgrade_points = 3
	model_current += 1
	# The dictionary's size limits the number of upgrades
	if model_current > dict_models.size() - 1:
		model_current = dict_models.size() - 1
		return
	$Model.get_child(0).queue_free()
	# Access the dictionary with the new model_current variable to load the new model
	var model_new: Node3D = dict_models[model_current].instantiate()
	if model_new:
		$Model.add_child(dict_models[model_current].instantiate())
		#Audio
	else:
		push_warning("Couldn't instantiate model" + str(model_current))


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
		var action_id: int
		# If making a special action (time or heal), then don't consume battery
		var action_is_special: bool = false
		# Cooldown for next action
		var action_time: int = 1
		#print(position)
		# TODO: Animationplayer for all the actions
		if text.contains("time"):
			# Slow down the dropping items
			#signal.time.emit() to world.gd
			action_is_special = true
			print("time")
		# Tiny model couldn't recognise this one very well
		elif text.contains("heal") or text.contains("heel") or text.contains("healing"):
			if not timer_healing.is_stopped():
				return
			# Start a timer to heal the bot (recharge battery)
			timer_healing.start()
			# Healing increases the amount of time to make the next action
			action_time = 3
			action_is_special = true
		elif text.contains("left") or text.contains("let"):
			# Check for position to stay in the 3x3 grid
			if position.x == -GRID_SIZE:
				return
			#position -= Vector3(GRID_SIZE, 0, 0)
			# Create a tween to tween position
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position:x", position.x - GRID_SIZE, 0.3)
			action_id = 0
		elif text.contains("right"):
			if position.x == GRID_SIZE:
				return
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position:x", position.x + GRID_SIZE, 0.3)
			action_id = 1
		elif text.contains("up"):
			if position.z == -GRID_SIZE:
				return
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position:z", position.z - GRID_SIZE, 0.3)
			action_id = 2
		elif text.contains("down"):
			if position.z == GRID_SIZE:
				return
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position:z", position.z + GRID_SIZE, 0.3)
			action_id = 3
		else: # Only if the player doesn't make any action
			action_made = false
	
		if action_made:
			if not action_is_special:
				health -= 1
				$UI.update_labels(points, health)
				timer_healing.stop()
				if health <= 0:
					#healing_start()
					#queue_free()
					death.emit()
					$UI/Quit.show()
			action.emit(action_id)
			# Restart action timer to prevent making actions too fast
			action_available = false
			$UI.update_listening(action_available)
			$UI.update_labels(points, health)
			# If healed action_time == 3 else 1
			timer_action.start(action_time)
	
