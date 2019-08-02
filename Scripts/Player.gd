extends KinematicBody2D

const GRAVITY: float = 600.0
const JUMP_FORCE: float = 300.0
const WALK_SPEED: int = 100

var velocity: Vector2 = Vector2.ZERO
var jumping: bool = false

# ==========================================================

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Left/right movement
	velocity.x = (int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))) * WALK_SPEED
	
	jumping = not is_on_floor()
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
	
	# Jump
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		_jump()
	
	# Apply velocity to player
	velocity = move_and_slide(velocity, Vector2(0, -1))

# ==========================================================

func _jump() -> void:
	velocity.y = -JUMP_FORCE
