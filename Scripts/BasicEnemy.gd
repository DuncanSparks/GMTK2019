extends KinematicBody2D

const GRAVITY: float = 600.0;
const JUMP_FORCE: float = 300.0;
var WALK_SPEED: int = -100;

var velocity: Vector2 = Vector2.ZERO;
var jumping = false;

func _ready() -> void:
	pass

func _physics_process(delta):
	if !$RayCast2D.is_colliding() or is_on_wall():
		WALK_SPEED *= -1;
	velocity.x = WALK_SPEED;
	
	velocity = move_and_slide(velocity, Vector2(0, 1))