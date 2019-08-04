extends KinematicBody2D

export (AudioStream) var footstep

export(Array, AudioStream) var sounds

const GRAVITY: float = 600.0
const JUMP_FORCE: float = 300.0
var WALK_SPEED: int = -100
var temp_speed: int = 0

var velocity: Vector2 = Vector2.ZERO;
var jumping := false
var charging: bool = false

onready var anim_player := $AnimationPlayer

func _ready() -> void:
	pass

func _physics_process(delta):
	if !$RayCast2D.is_colliding() or is_on_wall():
		WALK_SPEED *= -1
		if sign(WALK_SPEED) == 1:
			anim_player.play("WalkRight" if not charging else "ChargeRight")
			#anim_player.current_animation_position = 2.2
			anim_player.set_speed_scale(-2.5)
		elif sign(WALK_SPEED) == -1:
			anim_player.play("WalkLeft" if not charging else "ChargeLeft")
			#anim_player.current_animation_position = 2.2
			anim_player.set_speed_scale(-2.5)
	velocity.x = WALK_SPEED
	velocity = move_and_slide(velocity, Vector2(0, 1))


#func _on_PlayerAreaVicinityFront_body_shape_exited(body_id, body, body_shape, area_shape):
#	if body.name == "Player":
#		WALK_SPEED = temp_speed
#		temp_speed = 0
#
#
#func _on_PlayerAreaVicinityBack_body_shape_exited(body_id, body, body_shape, area_shape):
#	if body.name == "Player":
#		WALK_SPEED = temp_speed
#		temp_speed = 0
#
#
#func _on_PlayerAreaVicinityFront_body_shape_entered(body_id, body, body_shape, area_shape):
#	if body.name == "Player":
#		temp_speed = WALK_SPEED
#		WALK_SPEED = 300
#
#		velocity.x = (body.position.x - position.x) 
#
#		yield(get_tree().create_timer(3.0), "timeout")
#		print("wait man");
#		WALK_SPEED = temp_speed
#
#func _on_PlayerAreaVicinityBack_body_shape_entered(body_id, body, body_shape, area_shape):
#	if body.name == "Player":
#		temp_speed = WALK_SPEED
#		WALK_SPEED = -300
#
#		velocity = (body.position - position).normalize()

#func _on_HitArea_area_entered(area):
#	print(area.name)
#	if area.name == "HitArea":
#		temp_speed = WALK_SPEED
#		WALK_SPEED = 0
#
#		yield(get_tree().create_timer(3.0), "timeout")
#		WALK_SPEED = temp_speed
#		temp_speed = 0
#
#	if area.name == "PlayerHitArea":
#		get_tree().reload_current_scene()

func _on_HitArea_body_entered(body: PhysicsBody2D) -> void:
	if body != null and body.is_in_group("Player"):
		get_tree().reload_current_scene()
		
	#Eif body != null and body.is_in_group("Torch"):
	#	temp_speed = WALK_SPEED
	#	WALK_SPEED = 0

	#	yield(get_tree().create_timer(3.0), "timeout")
	#	WALK_SPEED = temp_speed
	#	temp_speed = 0


func _on_PlayerAreaVicinityFront_body_entered(body: PhysicsBody2D) -> void:
	if body != null and body.is_in_group("Player"):
		WALK_SPEED *= 3
		Controller.play_sound_burst(sounds[randi() % len(sounds)], 1, -20)
		anim_player.play("ChargeLeft" if sign(WALK_SPEED) == -1 else "ChargeRight")
		charging = true


func _on_PlayerAreaVicinityFront_body_exited(body: PhysicsBody2D) -> void:
	if body != null and body.is_in_group("Player"):
		WALK_SPEED /= 3
		anim_player.play("WalkLeft" if sign(WALK_SPEED) == -1 else "WalkRight")
		charging = false


func _on_PlayerAreaVicinityBack_body_entered(body: PhysicsBody2D) -> void:
	if body != null and body.is_in_group("Player"):
		WALK_SPEED *= 3
		Controller.play_sound_burst(sounds[randi() % len(sounds)], 1, -20)
		anim_player.play("WalkLeft" if sign(WALK_SPEED) == -1 else "WalkRight")
		charging = true


func _on_PlayerAreaVicinityBack_body_exited(body: PhysicsBody2D) -> void:
	if body != null and body.is_in_group("Player"):
		WALK_SPEED /= 3
		charging = false
