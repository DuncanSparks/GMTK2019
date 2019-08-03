extends Node

export(PoolStringArray) var dialogue_text = []
export(Array, Vector2) var dialogue_positions = []
export(PoolIntArray) var positions_to_use = []

const Torch_Inst := preload("res://Instances/ThrowableObject.tscn")

func _ready():
	pass
	
	
func play_cutscene() -> void:
	Controller.get_player().state = 1
	Controller.dialogue(dialogue_text, dialogue_positions, positions_to_use)
	yield(Controller, "dialogue_ended")
	#var 
