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
	


func _on_Area2D_area_entered(area):
	# print(area.name);
	if area.name == "HitArea":
		var temp_speed: int = WALK_SPEED;
		WALK_SPEED = 0;
		yield(get_tree().create_timer(3.0), "timeout")
		WALK_SPEED = temp_speed;


func _on_Area2D_body_entered(body):
	if body.is_in_group("Torch"):
		print("fuck")
		var temp_speed: int = WALK_SPEED
		WALK_SPEED = 0
		yield(get_tree().create_timer(3.0), "timeout")
		WALK_SPEED = temp_speed
