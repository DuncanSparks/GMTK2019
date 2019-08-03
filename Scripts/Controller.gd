extends Node

signal dialogue_ended

const Dialogue_Inst: PackedScene = preload("res://Instances/Dialogue.tscn")

func _ready():
	pass
	
	
func get_player() -> Player:
	return get_tree().get_root().get_node("Scene").get_node("Player") as Player


func dialogue(text: PoolStringArray, positions: Array, positions_to_use: PoolIntArray) -> void:
	var dlg: Dialogue = Dialogue_Inst.instance() as Dialogue
	dlg.dialogue = text
	#dlg.set_text_position(pos)
	dlg.positions = positions
	dlg.positions_to_use = positions_to_use
	dlg.start()
	get_tree().get_root().add_child(dlg)
	yield(dlg, "dialogue_ended")
	emit_signal("dialogue_ended")
