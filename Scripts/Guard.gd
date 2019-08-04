extends KinematicBody2D

const FLOAT_SPEED: int = 50
const STOP : int = 0

var direction: Vector2 = Vector2.ZERO
var throwableObject: ThrowableObject = null
var player = null;

enum State { MOVE, STOP }
var state = State.STOP

onready var anim_player := $AnimationPlayer

func _ready():
	player = Controller.get_player()
	throwableObject = get_tree().get_root().get_node("Scene").get_node("ThrowableObject")

func _physics_process(delta):
	state = State.STOP if throwableObject.held else State.MOVE
	
	match state:
		State.MOVE:
			direction = (player.position - position).normalized() * FLOAT_SPEED
		State.STOP:
			direction = (player.position - position).normalized() * STOP
			
	direction = move_and_slide(direction, player.position)
	
	#anim_player.set_assigned_animation("Left" if direction.x < 0 else "Right")
	
	if direction.x < 0:
		anim_player.set_assigned_animation("Left")
	elif direction.x > 0:
		anim_player.set_assigned_animation("Right")

#func _on_KillArea_area_entered(area):
	#print("TEST")
	#get_tree().reload_current_scene()


func _on_KillArea_body_entered(body: PhysicsBody2D) -> void:
	if body != null and body.is_in_group("Player"):
		get_tree().reload_current_scene()
