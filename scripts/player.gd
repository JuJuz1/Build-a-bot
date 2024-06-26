extends CharacterBody3D
## Player character

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

## Used to limit how many actions the player can perform in a time limit
var action_available: bool = true
const TIME_FOR_ACTION: float = 1.0
@onready var timer_action: Timer = $Timer

## Size for the grid, how much the player will move with each action
const GRID_SIZE: int = 1

func _ready() -> void:
	timer_action.wait_time = TIME_FOR_ACTION
	timer_action.timeout.connect(enable_action)


func enable_action() -> void:
	action_available = true
	print(action_available)


"""
func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#if speech "jump":
		# velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
"""


## Performing character actions based on transcribed speech to text
func _on_capture_stream_to_text_updated_player(text : String) -> void:
	print(text)
	#if not action_available or text.is_empty():
		#return
	# Everything to lower case
	text = text.to_lower()
	# Remove first space
	#text = text.substr(1, text.length())
	# Find the first index of a space
	#var index: int = text.findn(" ")
	# Take the first word, if index is -1, returns the original string back
	# This happens only if text has 1 word
	#text = text.substr(0, index)
	if action_available:
		var made_action: bool = false
		print(position)
		if text.contains("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			made_action = true
		elif text.contains("left"):
			# TODO: Animationplayer for all the movement related stuff
			if position.x == -GRID_SIZE:
				return
			position -= Vector3(GRID_SIZE, 0, 0)
			made_action = true
		elif text.contains("right"):
			if position.x == GRID_SIZE:
				return
			position += Vector3(GRID_SIZE, 0, 0)
			made_action = true
		elif text.contains("up"):
			if position.z == -GRID_SIZE:
				return
			position -= Vector3(0, 0, GRID_SIZE)
			made_action = true
		elif text.contains("down"):
			if position.z == GRID_SIZE:
				return
			position += Vector3(0, 0, GRID_SIZE)
			made_action = true
	
		if made_action:
			# Restart action timer to prevent making actions too fast
			action_available = false
			timer_action.start()
