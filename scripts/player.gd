extends CharacterBody3D
## Player character

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

## Used to limit how many actions the player can perform in a time limit
var action_available: bool = true
const time_for_action: float = 2.0
@onready var timer_action: Timer = $Timer

func _ready() -> void:
	timer_action.wait_time = time_for_action
	timer_action.timeout.connect(enable_action)


func enable_action() -> void:
	action_available = true
	print(action_available)


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


## Performing character actions based on transcribed speech to text
func _on_capture_stream_to_text_updated_player(text : String):
	print(text)
	if not action_available or text.is_empty():
		return
	# Everything to lower case
	text = text.to_lower()
	# Remove first space
	text = text.substr(1, text.length())
	# Find the first index of a space
	var index: int = text.findn(" ")
	# Take the first word, if index is -1, returns the original string back
	# This happens only if text has 1 word
	text = text.substr(0, index)
	if action_available:
		action_available = false
		timer_action.start()
		if text.contains("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			print(text)
		#if text.contains("left") and is_on_floor():
			#velocity.x = SPEED
