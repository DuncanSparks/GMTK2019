extends Node2D

func _on_TimerRestart_timeout() -> void:
	get_tree().change_scene("res://Scenes/Title.tscn")
