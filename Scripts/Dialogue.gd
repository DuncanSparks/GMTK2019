extends Node2D

class_name Dialogue

signal dialogue_ended

const SPEED: float = 1.0

var dialogue: PoolStringArray = []
var dialogue_page: int = 0
var positions: Array = []
var positions_to_use: PoolIntArray = []

var disp: int = 0
var roll: bool = false
var buffer: bool = false

onready var canvas_layer: CanvasLayer = $CanvasLayer as CanvasLayer
onready var text: Label = $CanvasLayer/Text as Label

# ==========================================================

func _process(delta: float) -> void:
	text.set_text(dialogue[dialogue_page])
	text.set_visible_characters(disp)
	canvas_layer.set_offset(positions[positions_to_use[dialogue_page]])
		
	if Input.is_action_just_pressed("sys_accept") and not buffer:
		if disp >= len(dialogue[dialogue_page]):
			advance_page()
		else:
			disp = len(dialogue[dialogue_page])
			buffer = true
			$TimerBuffer.start()
		
# ==========================================================

func set_text_position(pos: Vector2) -> void:
	$CanvasLayer.offset = pos

func start() -> void:
	roll = true
	$TimerRollText.start()


func advance_page() -> void:
	if dialogue_page < len(dialogue) - 1:
		dialogue_page += 1
		disp = 0
		roll = true
		$TimerRollText.start()
		buffer = true
		$TimerBuffer.start()
	else:
		emit_signal("dialogue_ended")
		queue_free()

# ==========================================================

func _on_TimerRollText_timeout() -> void:
	if roll and disp < len(dialogue[dialogue_page]):
		disp += 1
	else:
		$TimerRollText.stop()
	
	
func _on_TimerBuffer_timeout() -> void:
	buffer = false
