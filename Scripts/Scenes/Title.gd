extends Node2D

var over: int = -1
var input: bool = false
var credits: bool = false

onready var anim_player := $AnimationPlayer2

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_throw"):
		if input:
			input = false
			match over:
				0:
					print("ONE")
				1:
					anim_player.play("Credits In")
					#credits = true
				2:
					anim_player.play("Exit")
		if credits:
			credits = false
			anim_player.play("Credits Out")


func enable_input() -> void:
	input = true
	
	
func enable_credits() -> void:
	credits = true


func exit_game() -> void:
	get_tree().quit()


func _on_Area1_mouse_entered() -> void:
	over = 0


func _on_Area2_mouse_entered() -> void:
	over = 1


func _on_Area3_mouse_entered() -> void:
	over = 2


func _on_Area1_mouse_exited() -> void:
	over = -1
