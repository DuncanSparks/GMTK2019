extends Node

export(PoolStringArray) var dialogue_text = []
export(Array, Vector2) var dialogue_positions = []
export(PoolIntArray) var positions_to_use = []

export(PoolStringArray) var dialogue_text_2 = []
export(Array, Vector2) var dialogue_positions_2 = []
export(PoolIntArray) var positions_to_use_2 = []

export(PoolStringArray) var dialogue_text_3 = []
export(Array, Vector2) var dialogue_positions_3 = []
export(PoolIntArray) var positions_to_use_3 = []

export(NodePath) var anim_player

export(PackedScene) var target_scene

const Torch_Inst := preload("res://Instances/ThrowableObject.tscn")
	
	
func play_cutscene() -> void:
	Controller.get_player().state = 1
	Controller.dialogue(dialogue_text_3, dialogue_positions_3, positions_to_use_3)
	yield(Controller, "dialogue_ended")
	
	Controller.get_player().get_node("AnimationPlayer2").play("IdleRight")
	get_node(anim_player).play("Fade in")
	yield(get_tree().create_timer(2.5), "timeout")
	
	Controller.dialogue(dialogue_text, dialogue_positions, positions_to_use)
	yield(Controller, "dialogue_ended")
	
	var torch := Torch_Inst.instance()
	torch.set_position(Vector2(440, -150))
	get_tree().get_root().get_node("Scene").get_node("Torch").add_child(torch)
	yield(get_tree().create_timer(3.0), "timeout")
	
	Controller.dialogue(dialogue_text_2, dialogue_positions_2, positions_to_use_2)
	yield(Controller, "dialogue_ended")
	
	get_node(anim_player).play("Fade out")
	yield(get_tree().create_timer(4.0), "timeout")
	
	get_tree().change_scene_to(target_scene)