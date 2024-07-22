extends CharacterBody3D
class_name Player
## Player character

## Signals
signal death ## Emitted to world on death
signal action(action_id: int) ## Emitted to world/UI to flash labels on screen
signal time(enabled: bool) ## Emitted to itemdropper when slowing down time
signal point_gap_reached ## Emitted to itemdropper to increase difficulty
signal damage_taken ## Emits to camera to apply shake effect

## Used to limit how many actions the player can perform in a time limit
var action_available: bool = true
const TIME_FOR_ACTION: float = 1.0
@onready var timer_action: Timer = $TimerAction

## Time it takes to start healing, cycle length (same) and healing amount
const TIME_FOR_HEAL: float = 2.0
const HEAL_AMOUNT: int = 2
@onready var timer_healing: Timer = $TimerHealing

## Time action's cooldown and length
const TIME_ACTION_COOLDOWN: int = 20
const TIME_LENGTH: int = 8
@onready var timer_time: Timer = $TimerTime
@onready var timer_time_cooldown: Timer = $TimerTimeCooldown

## Size for the grid (one tile), how much the player will move with each movement action
const GRID_SIZE: float = 3 ## Keeping it float to prevent possible errors calulating position

## Current point count and health
var points: int = 0
var health: int = 30
var action_cost: int = 1 ## How much health 1 action takes
const POINTS_GAP: int = 100 ## When reached, difficulty increases (see itemdropper), also increases action_cost to 2
var point_gap_reached_emitted: bool = false

## Points to tell when the robot will be upgraded (how many are needed till the next)
var upgrade_points: int = 3
var model_current: int = 0

## Robot's models
const ROBOT_MODEL_0: PackedScene = preload("res://graphics/blender/robot_model_0.blend")
const ROBOT_MODEL_1: PackedScene = preload("res://graphics/blender/robot_model_1.blend")
const ROBOT_MODEL_2: PackedScene = preload("res://graphics/blender/robot_model_2.blend")
const ROBOT_MODEL_3: PackedScene = preload("res://graphics/blender/robot_model_3.blend")
const ROBOT_MODEL_4: PackedScene = preload("res://graphics/blender/robot_model_4.blend")
## Dictionary to hold all the upgrade models with the corresponding "phase" of the robot
var dict_models: Dictionary = {0: ROBOT_MODEL_0, 1: ROBOT_MODEL_1, 2: ROBOT_MODEL_2, 3: ROBOT_MODEL_3, 4: ROBOT_MODEL_4} ## Size is 5

## Audio
@onready var audio_upgrade: AudioStreamPlayer = $AudioUpgrade
@onready var audio_heal: AudioStreamPlayer = $AudioHeal
@onready var audio_time: AudioStreamPlayer = $AudioTime
@onready var audio_damage: AudioStreamPlayer = $AudioDamage
@onready var audio_death: AudioStreamPlayer = $AudioDeath

func _ready() -> void:
	$UI.update_labels(points, health)
	timer_action.wait_time = TIME_FOR_ACTION
	timer_action.timeout.connect(action_enable)
	
	timer_healing.wait_time = TIME_FOR_HEAL
	timer_healing.timeout.connect(heal)
	
	timer_time.wait_time = TIME_LENGTH
	timer_time.timeout.connect(func() -> void: 
		time.emit(false)
		$UI.texture_update(1, false))
	
	timer_time_cooldown.wait_time = TIME_ACTION_COOLDOWN
	
	#health = 1
	# TODO: comment out
	#upgrade_points = 1
	#model_current = 4


## Enable action to control player
func action_enable() -> void:
	action_available = true
	$UI.texture_update(0, action_available)


## Increase health when healing
func heal() -> void:
	health += HEAL_AMOUNT
	if health > 30:
		health = 30
	$UI.update_labels(points, health)
	audio_heal.play()


## When picking up item
func _on_item_picked_up(item: RigidBody3D) -> void:
	if item.health < 0:
		damage_taken.emit()
		audio_damage.play()
	health += item.health
	if health > 30:
		health = 30
	points += item.points
	if points > POINTS_GAP: # Only applies once
		if point_gap_reached_emitted:
			return
		point_gap_reached.emit()
		point_gap_reached_emitted = true
		action_cost = 2
	if points < 0:
		points = 0
	$UI.update_labels(points, health)
	if health <= 0:
		#queue_free()
		death.emit()
		$UI/Quit.show()
		audio_death.play()
	if item.robot_upgrade:
		upgrade_points -= 1
		if upgrade_points <= 0:
			upgrade()


## Upgrades the robot's model
func upgrade() -> void:
	#TODO: change to 3
	upgrade_points = 3 # 3
	
	model_current += 1
	# The dictionary's size limits the number of upgrades
	if model_current > dict_models.size() - 1:
		model_current = dict_models.size() - 1
		return
	if model_current == 4:
		if $UI/TextureTime.visible:
			return
		$UI.enable_time_texture()
		# Show message that player can use time action
	$Model.get_child(0).queue_free()
	# Access the dictionary with the new model_current variable to load the new model
	var model_new: Node3D = dict_models[model_current].instantiate()
	if model_new:
		$Model.add_child(dict_models[model_current].instantiate())
		var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property($Model, "scale", Vector3(1.5, 1.5, 1.5), 0.25)
		tween.tween_property($Model, "scale", Vector3.ONE, 0.1)
		health += 10
		if health > 30:
			health = 30
		$UI.update_labels(points, health)
		audio_upgrade.play()
	else:
		push_warning("Couldn't instantiate model" + str(model_current))


## When player gets hit by a danger
func _on_danger_player_damaged(damage: int):
	health -= damage
	damage_taken.emit()
	audio_damage.play()
	$UI.update_labels(points, health)
	if health <= 0:
		death.emit()
		$UI/Quit.show()
		audio_death.play()


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
		# Used to flash the correct label on screen
		var action_id: int
		# If making a special action (time or heal), then don't consume battery
		var action_is_special: bool = false
		# Cooldown for next action
		var action_time: int = 1
		#print(position)
		if text.contains("time"):
			# Time action only available when robot fully upgraded
			if not (model_current == dict_models.size() - 1 and timer_time_cooldown.is_stopped()):
				return
			action_is_special = true
			# Slow down the dropping items
			time.emit(true)
			# Start both timers
			timer_time.start()
			timer_time_cooldown.start()
			$UI.texture_update(1, true)
			audio_time.play()
		# Tiny model couldn't recognise this one very well
		elif text.contains("heal") or text.contains("heel") or text.contains("here") or text.contains("healing"):
			if not timer_healing.is_stopped():
				return
			# Start a timer to heal the bot (recharge battery)
			timer_healing.start()
			$UI.texture_update(2, true)
			# Healing increases the amount of time to make the next action
			action_time = 3
			action_is_special = true
		elif text.contains("left") or text.contains("let") or text.contains("of"):
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
				health -= action_cost
				$UI.update_labels(points, health)
				timer_healing.stop()
				$UI.texture_update(2, false)
				if health <= 0:
					#healing_start()
					#queue_free()
					death.emit()
					$UI/Quit.show()
					audio_death.play()
			action.emit(action_id)
			# Restart action timer to prevent making actions too fast
			action_available = false
			$UI.texture_update(0, action_available)
			$UI.update_labels(points, health)
			# If healed action_time == 3 else 1
			timer_action.start(action_time)
