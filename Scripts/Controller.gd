extends Node

func _ready():
	pass
	
	
func get_player() -> Player:
	return get_tree().get_root().get_node("Scene").get_node("Player") as Player
