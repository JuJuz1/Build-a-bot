extends TextureRect
## Updates texture on screen

## Update the alpha channel value to match the state
func state_update(enabled: bool) -> void:
	if enabled:
		modulate.a = 1
	else:
		modulate.a = 0.25
