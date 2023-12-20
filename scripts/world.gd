extends Node3D

@onready var player1 = $animated_Platformer_Character
@onready var player2 = $"Character Animated"
@onready var pause_menu = $PauseMenu

var paused = false

var winCounterP1 = 0
var winCounterP2 = 0

var player_character_path = "res://scenes/games/animated_platformer_character.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pauseMenu()
		
	if Input.is_action_just_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if player1.current_health <= 0 :
		$TimerGame.stop()
		player1.enable_controls = false
		player2.enable_controls = false
		$LabelWinner.set_text("player 2 wins")
		$LabelWinner.visible = true
		winCounterP2 += 1
		if $TimerRoundEnd.is_stopped():
			$TimerRoundEnd.start()
	
	if player2.current_health <= 0 :
		$TimerGame.stop()
		player1.enable_controls = false
		player2.enable_controls = false
		$LabelWinner.set_text("player 1 wins")
		$LabelWinner.visible = true
		winCounterP1 += 1
		if $TimerRoundEnd.is_stopped():
			$TimerRoundEnd.start()
	
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
	
func pauseMenu():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	if paused :
		pause_menu.hide()
		Engine.time_scale = 1
		player1.enable_controls = true
		player2.enable_controls = true
	else:
		pause_menu.show()
		Engine.time_scale = 0
		player1.enable_controls = false
		player2.enable_controls = false

	paused = !paused
	
