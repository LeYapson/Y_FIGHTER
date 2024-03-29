extends Node3D

@onready var player1 = $Player1
@onready var player2 = $Player2
@onready var pause_menu = $PauseMenu

var paused = false

var winCounterP1 = 0
var winCounterP2 = 0
var roundEnded = false

var player_character_path = "res://scenes/games/animated_platformer_character.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	player1.enableControls = false
	player2.enableControls = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
	if Input.is_action_just_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if player1.currentHealth <= 0 :
		$TimerGame.stop()
		Engine.time_scale = 0.5
		player1.enableControls = false
		player2.enableControls = false
		$LabelWinner.set_text("player 2 wins")
		$LabelWinner.visible = true
		roundEnded = true
#		winCounterP1 += 1

		if $TimerRoundEnd.is_stopped():
			$TimerRoundEnd.start()

	if player2.currentHealth <= 0 :
		$TimerGame.stop()
		Engine.time_scale = 0.5
		player1.enableControls = false
		player2.enableControls = false
		$LabelWinner.set_text("player 1 wins")
		$LabelWinner.visible = true
		roundEnded = true
#		winCounterP1 += 1

		if $TimerRoundEnd.is_stopped():
			$TimerRoundEnd.start()
	
#	$TimerGame/LabelTimerGame.set_text(str($TimerGame.get_time_left()))
	if str($TimerRoundStart.get_time_left()).pad_decimals(0) > '0':
		$TimerRoundStart/Label.set_text(str($TimerRoundStart.get_time_left()).pad_decimals(0))
	else:
		$TimerRoundStart/Label.set_text('FIGHT')
		
	$TimerGame/LabelTimerGame.set_text(str($TimerGame.get_time_left()).pad_decimals(0))
#	$TimerRoundEnd/Label.set_text(str($TimerRoundEnd.get_time_left()).pad_decimals(0))

func _on_timer_game_timeout():
	player1.enableControls = false
	player2.enableControls = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if player1.currentHealth > player2.currentHealth:
		$LabelWinner.set_text("player 1 wins")
		$LabelWinner.visible = true
		winCounterP1 += 1
	elif player2.currentHealth > player1.currentHealth:
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
	player1.enableControls = true
	player2.enableControls = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player1.heal()
	player2.heal()
	Engine.time_scale = 1
	$TimerGame.start()
	$TimerRoundEnd.stop()
	
func pauseMenu():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	if paused :
		pause_menu.hide()
#		get_tree().paused = false
		Engine.time_scale = 1
		player1.enableControls = true
		player2.enableControls = true
	else:
		pause_menu.show()
#		get_tree().paused = true
		Engine.time_scale = 0
		player1.enableControls = false
		player2.enableControls = false
	paused = !paused
	
func _on_timer_round_start_timeout():
	$TimerGame.start()
	$TimerGame/LabelTimerGame.visible = true
	$TimerRoundStart/Label.visible = false
	player1.enableControls = true
	player2.enableControls = true
