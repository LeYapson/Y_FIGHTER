extends Node3D

@onready var player1 = $animated_Platformer_Character
@onready var player2 = $"Character Animated"

var winCounterP1 = 0
var winCounterP2 = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#	$TimerGame/LabelTimerGame.set_text(str($TimerGame.get_time_left()))
	$TimerGame/LabelTimerGame.set_text(str($TimerGame.get_time_left()).pad_decimals(0))
	$TimerRoundEnd/Label.set_text(str($TimerRoundEnd.get_time_left()).pad_decimals(0))

func _on_timer_game_timeout():
	player1.enable_controls = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if player1.current_health > player2.current_health:
		$LabelWinner.set_text("player 1 wins")
		$LabelWinner.visible = true
		winCounterP1 += 1
	elif player2.current_health > player1.current_health:
		$LabelWinner.set_text("player 2 wins")
		$LabelWinner.visible = true
		winCounterP2 += 1
	else:
		$LabelWinner.set_text("draw")
		$LabelWinner.visible = true
	$TimerRoundEnd.start()

func _on_timer_round_end_timeout():
	restart_round()

func restart_round():
	$LabelWinner.visible = false
	player1.enable_controls = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player1.heal()
	player2.heal()
	$TimerGame.start()
	$TimerRoundEnd.stop()
	
