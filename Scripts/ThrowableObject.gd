extends KinematicBody2D

const GRAVITY: float = 600.0

var player_in_area: bool = false
var grabbable: bool = true
var held: bool = false
var thrown: bool = false
var returnback: bool = false
var cooldown: bool = false

var velocity: Vector2 = Vector2.ZERO

onready var coll := $CollisionShape2D

func _ready():
	Controller.get_player().held_object = self
	
func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor() and not held and not returnback:
		velocity.y += GRAVITY * delta
	elif not thrown:
		velocity = Vector2.ZERO
	
	# Apply velocity
	if not held:
		velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# Pick up
	if Input.is_action_just_pressed("action_grab") and player_in_area and not held and grabbable:
		Controller.get_player().held_object = self
		Controller.get_player().holding = true
		held = true
	
	# Recall to player
	if Input.is_action_just_pressed("action_return") and not held and not cooldown:
		returnback = true
		cooldown = true
		Controller.get_player().trigger_progress_bar()
		($TimerCooldown as Timer).start()
		($TimerReturn as Timer).start()
		
	coll.set_disabled(returnback)
	
	if returnback:
		position = position.linear_interpolate(Controller.get_player().get_position(), 0.1)
		

func _on_GrabArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = true


func _on_GrabArea_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false


func _on_TimerDrop_timeout() -> void:
	grabbable = true


func _on_TimerThrown_timeout() -> void:
	thrown = false


func _on_TimerReturn_timeout() -> void:
	returnback = false


func _on_TimerCooldown_timeout() -> void:
	cooldown = false
