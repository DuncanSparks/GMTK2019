extends Node2D

export(PackedScene) var start_scene
export(AudioStream) var hover_sound
export(AudioStream) var click_sound

var over: int = -1
var input: bool = false
var credits: bool = false

onready var anim_player := $AnimationPlayer2

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_throw"):
		if input and over != -1:
			Controller.play_sound_burst(click_sound)
			input = false
			match over:
				0:
					anim_player.play("Start Game")
				1:
					anim_player.play("Credits In")
				2:
					anim_player.play("Exit")
		if credits:
			credits = false
			anim_player.play("Credits Out")


func enable_input() -> void:
	input = true
	
	
func enable_credits() -> void:
	credits = true
	
	
func start_game() -> void:
	get_tree().change_scene_to(start_scene)


func exit_game() -> void:
	get_tree().quit()


func _on_Area1_mouse_entered() -> void:
	if input:
		Controller.play_sound_burst(hover_sound, 1, -20)
	over = 0


func _on_Area2_mouse_entered() -> void:
	if input:
		Controller.play_sound_burst(hover_sound, 1, -20)
	over = 1


func _on_Area3_mouse_entered() -> void:
	if input:
		Controller.play_sound_burst(hover_sound, 1, -20)
	over = 2


func _on_Area1_mouse_exited() -> void:
	over = -1


func _on_AnimationPlayer2_animation_finished(anim_name: String) -> void:
	if anim_name == "Fade in":
		enable_input()
