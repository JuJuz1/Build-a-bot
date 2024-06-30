extends Label3D
## Script to flash label on screen when player makes an action

## Modulate alpha channel value
const ALPHA: float = 0.1

## Animationplayer is overkill
var tween: Tween

## Set alpha channel visibility to 0.25
func _ready() -> void:
	modulate.a = ALPHA


## Flashes label shortly
func flash() -> void:
	# Should never happen as TIME_FOR_ACTION in player is 1
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(self, "modulate:a", 1, 0.4)
	tween.tween_property(self, "scale", Vector3(1.5, 1.5, 1.5), 0.4)
	tween.chain().tween_property(self, "modulate:a", ALPHA, 0.2)
	tween.tween_property(self, "scale", Vector3.ONE, 0.2)
