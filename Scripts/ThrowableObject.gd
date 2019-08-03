extends KinematicBody2D

const GRAVITY: float = 600.0

var player_in_area: bool = false
var grabbable: bool = true
var held: bool = false


var velocity: Vector2 = Vector2.ZERO

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
	
	# Apply velocity
	if not held:
		velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if Input.is_action_just_pressed("action_grab") and player_in_area and not held and grabbable:
		Controller.get_player().held_object = self
		Controller.get_player().holding = true
		held = true
		

func _on_GrabArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = true


func _on_GrabArea_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false


func _on_TimerDrop_timeout() -> void:
	grabbable = true
