extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	
func play(sfx = null):
	if(sfx):
		get_node(sfx).play()
	else:
		var rand = randi()%get_child_count()
		get_child(rand).play()
