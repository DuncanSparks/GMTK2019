extends KinematicBody2D

const GRAVITY: float = 600.0
const JUMP_FORCE: float = 300.0
var WALK_SPEED: int = -100
var temp_speed: int = 0

var velocity: Vector2 = Vector2.ZERO;
var jumping = false;

onready var anim_player := $AnimationPlayer

func _ready() -> void:
	pass

func _physics_process(delta):
	if !$RayCast2D.is_colliding() or is_on_wall():
		WALK_SPEED *= -1;
		if sign(WALK_SPEED) == 1:
			anim_player.play("WalkRight")
			#anim_player.current_animation_position = 2.2
			anim_player.set_speed_scale(-2.5)
		elif sign(WALK_SPEED) == -1:
			anim_player.play("WalkLeft")
			#anim_player.current_animation_position = 2.2
			anim_player.set_speed_scale(-2.5)
	velocity.x = WALK_SPEED
	
	velocity = move_and_slide(velocity, Vector2(0, 1))


func _on_PlayerAreaVicinityFront_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.name == "Player":
		WALK_SPEED = temp_speed
		temp_speed = 0


func _on_PlayerAreaVicinityBack_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.name == "Player":
		WALK_SPEED = temp_speed
		temp_speed = 0


func _on_PlayerAreaVicinityFront_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == "Player":
		temp_speed = WALK_SPEED
		WALK_SPEED = 300
		yield(get_tree().create_timer(3.0), "timeout")
		print("wait man");
		WALK_SPEED = temp_speed
		
func _on_PlayerAreaVicinityBack_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == "Player":
		temp_speed = WALK_SPEED
		WALK_SPEED = -300

func _on_HitArea_area_entered(area):
	if area.name == "HitArea":
		temp_speed = WALK_SPEED
		WALK_SPEED = 0
		yield(get_tree().create_timer(3.0), "timeout")
		WALK_SPEED = temp_speed
		temp_speed = 0
