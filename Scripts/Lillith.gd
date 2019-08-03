extends KinematicBody2D

var WALK_SPEED: int = -50
var temp_speed: int = 0

var velocity: Vector2 = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _physics_process(delta):
	if !$RayCast2D.is_colliding():
		yield(get_tree().create_timer(3.0), "timeout")
		WALK_SPEED *= -1;
	velocity.x = WALK_SPEED;
	
	velocity = move_and_slide(velocity, Vector2(0, 1))

func _on_FrontVicinityArea_area_entered(area):
	if area.name == "HitArea":
		WALK_SPEED = 50
		velocity = move_and_slide(velocity, area.position)
		
	if area.name == "DetectArea":
		print('yea'); 
		get_node("Weapon").show()
		get_node("Weapon")._on_AnimationPlayer_animation_started("_setup")
		# $Weapon/AnimationPlayer.Play("_setup");
		# $ColorRect3/AnimationPlayer.Play("_setup");
	


func _on_BackVicinityArea_area_entered(area):
	if area.name == "HitArea":
		WALK_SPEED = -50
		velocity = move_and_slide(velocity, area.position)
	
