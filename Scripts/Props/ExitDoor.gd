extends Area2D

export(PackedScene) var next_level

# ==========================================================

func _ready():
	pass

# ==========================================================

func _on_ExitDoor_body_entered(body: PhysicsBody2D) -> void:
	if body != null and body.is_in_group("Player"):
		Controller.fade(1, true)
