extends Camera3D
## Camera shake

## Noise returns values in range [-1, 1]
## This is how much the value will be multiplied by
const NOISE_SHAKE_STRENGTH: float = 50.0

## How long the shake will last (higher value -> lower time)
const SHAKE_DECAY_RATE: float = 30.0

## Noise "seed" that changes every frame
var noise_seed: float = 0.0
## How strong the shake is, see NOISE_SHAKE_STRENGTH (real strength)
var shake_strength: float = 0.0

## Noise to generate random values
var noise: FastNoiseLite = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Called when player takes any damage
## Assigns the constant value to shake_strength that will be interpolated
func apply_shake() -> void:
	shake_strength = NOISE_SHAKE_STRENGTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	# Fade out the intensity over time
	# lerpf decreases shake_strength by SHAKE_DECAY_RATE * delta and assigns it to the variable
	shake_strength = lerpf(shake_strength, 0, SHAKE_DECAY_RATE * delta)
	
	# Adjust camera position by random generated noise
	var noise_offset: Vector2 = get_noise_offset(delta)
	h_offset = noise_offset.x
	v_offset = noise_offset.y


## Generate random x (horizontal) and y (vertical) offset
## Simply -> generate random values for a Vector2 coordinates
func get_noise_offset(delta: float) -> Vector2:
	# Generate a seed
	noise_seed += NOISE_SHAKE_STRENGTH * delta
	
	# x and y coordinates apart so that generates from different areas of the noise
	return Vector2(
		noise.get_noise_2d(1, noise_seed * shake_strength),
		noise.get_noise_2d(100, noise_seed * shake_strength)
	)
