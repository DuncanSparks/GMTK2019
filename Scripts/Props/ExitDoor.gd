extends Area2D

export(PackedScene) var next_level

var in_area: bool = false

# ==========================================================

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_door") and in_area:
		Controller.fade(1, true)

# ==========================================================

func _on_ExitDoor_body_entered(body: PhysicsBody2D) -> void:
	if body != null and body.is_in_group("Player"):
		$AnimationPlayer.play("Fadein")
		in_area = true


func _on_ExitDoor_body_exited(body: PhysicsBody2D) -> void:
	if body != null and body.is_in_group("Player"):
		$AnimationPlayer.play("Fadeout")
		in_area = false
