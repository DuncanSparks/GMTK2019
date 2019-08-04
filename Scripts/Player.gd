extends KinematicBody2D

class_name Player

export(AudioStream) var teleport_sound
export(AudioStream) var walk_sound
export(AudioStream) var jump_sound

const GRAVITY: float = 600.0
const JUMP_FORCE: float = 300.0
const WALK_SPEED: int = 100
var HOLD_POSITION: Vector2 = Vector2(12, -12)

var velocity: Vector2 = Vector2.ZERO
var right := false
var throwing := false

var can_jump := false

var holding: bool = false
var held_object: KinematicBody2D = null

enum State { MOVE, NO_INPUT }
var state = State.MOVE

onready var anim_player := $AnimationPlayer2
onready var spr := $Sprite2

# ==========================================================

func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	update()
	
	if Input.is_action_just_pressed("debug_1"):
		#Controller.dialogue(["HELLO", "THERE"], Vector2(540, 228))
		get_tree().get_root().get_node("Scene").get_node("CutsceneIntro").play_cutscene()

	
func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
	
	match state:
		State.MOVE:
			# Left/right movement
			velocity.x = (int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))) * WALK_SPEED
			
			# Jump
			if Input.is_action_just_pressed("move_jump") and can_jump:
				_jump()
				Controller.play_sound_burst(jump_sound, rand_range(0.95, 1.05), -24)
				can_jump = false
			
			if Input.is_action_just_pressed("action_teleport"):
				Controller.play_sound_burst(teleport_sound, rand_range(0.95, 1.05), -20)
				set_position(held_object.get_position() + Vector2(0, -10))
			
			if holding:
				held_object.set_position(get_position() + HOLD_POSITION)
				
				if Input.is_action_just_pressed("action_throw"):
					throwing = true
					anim_player.play("ThrowRight" if right else "ThrowLeft")
					holding = false
					held_object.thrown = true
					held_object.grabbable = false
					held_object.held = false
					var vel := (get_global_mouse_position() - held_object.get_global_position()).normalized() * held_object.get_global_position().distance_to(get_global_mouse_position()) * 3
					held_object.velocity = vel
					held_object.spin_speed = sqrt(vel.x * vel.x + vel.y * vel.y)
					held_object.get_node("TimerDrop").start()
					held_object.get_node("TimerThrown").start()
					#held_object = null
				
				if Input.is_action_just_pressed("action_grab"):
					holding = false
					held_object.grabbable = false
					held_object.held = false
					held_object.get_node("TimerDrop").start()
					#held_object = null
					
	_animation()
					
	# Apply velocity to player
	velocity = move_and_slide(velocity, Vector2(0, -1))
			
			
func _draw() -> void:
	if holding:
		draw_line(HOLD_POSITION, get_local_mouse_position(), Color(1, 1, 1, 1), 5.0)
		
# ==========================================================

func trigger_progress_bar() -> void:
	$AnimationPlayer.play("Bar Fill")

# ==========================================================

func _jump() -> void:
	velocity.y = -JUMP_FORCE
	
	
func _end_throw() -> void:
	throwing = false
	
	
func _animation() -> void:
	if velocity.x < 0:
		right = false
	elif velocity.x > 0:
		right = true
		
	
		
	if not throwing:
		if can_jump:
			if velocity.x != 0:
				anim_player.play("WalkRight" if right else "WalkLeft")
			else:
				anim_player.play("IdleRight" if right else "IdleLeft")
		else:
			spr.vframes = 1
			spr.hframes = 17
			anim_player.play("JumpRight" if right else "JumpLeft")
	else:
		anim_player.play("ThrowRight" if right else "ThrowLeft")
		
	if state == State.NO_INPUT:
		anim_player.play("IdleRight")
	
		
	#else:
	#	anim_player.set_assigned_animation("JumpRight" if right else "JumpLeft")
		
	HOLD_POSITION.x = 12 if right else -11
	


func _on_FloorArea_body_entered(body: PhysicsBody2D) -> void:
	if body == null:
		can_jump = true
