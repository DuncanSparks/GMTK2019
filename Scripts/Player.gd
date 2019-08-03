extends KinematicBody2D

class_name Player

const GRAVITY: float = 600.0
const JUMP_FORCE: float = 300.0
const WALK_SPEED: int = 100
const HOLD_POSITION: Vector2 = Vector2(0, -50)

var velocity: Vector2 = Vector2.ZERO

var holding: bool = false
var held_object: KinematicBody2D = null

enum State { MOVE, NO_INPUT }
var state = State.MOVE

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
			if Input.is_action_just_pressed("move_jump") and is_on_floor():
				_jump()
			
			if Input.is_action_just_pressed("action_teleport"):
				set_position(held_object.get_position())
			
			if holding:
				held_object.set_position(get_position() + HOLD_POSITION)
				
				if Input.is_action_just_pressed("action_throw"):
					holding = false
					held_object.thrown = true
					held_object.grabbable = false
					held_object.held = false
					held_object.velocity = (get_global_mouse_position() - held_object.get_global_position()).normalized() * held_object.get_global_position().distance_to(get_global_mouse_position()) * 3
					held_object.get_node("TimerDrop").start()
					held_object.get_node("TimerThrown").start()
					#held_object = null
				
				if Input.is_action_just_pressed("action_grab"):
					holding = false
					held_object.grabbable = false
					held_object.held = false
					held_object.get_node("TimerDrop").start()
					#held_object = null
					
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
