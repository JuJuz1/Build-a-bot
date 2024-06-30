extends Control
## World UI management


## When player takes movement action for now
func _on_player_action(action_id: int) -> void:
	get_children()[action_id].flash()
