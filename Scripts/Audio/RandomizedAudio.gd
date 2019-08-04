extends Node

export(Array, AudioStream) var clips

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	
func randomized_playback():
	if(len(clips) > 0):
		var rand = randi() % len(clips)
		Controller.play_sound_burst(clips[rand], rand_range(0.90, 1.10), rand_range(-35, -30))
