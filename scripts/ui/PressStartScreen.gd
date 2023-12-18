extends Control
var konami_code = [KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_LEFT, KEY_RIGHT, KEY_B, KEY_A]
var konami_index := 0

func _ready():
	$PressStartLayer/startingFixe.play()
	set_process_input(true)
	set_process(true)

func _process(delta):
	cheat_code()
	if not $PressStartLayer/startingFixe.is_playing():
		$PressStartLayer/startingFixe.play()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		$PressStartLayer/AnimationPlayer.play("SlideOut")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SlideOut":
		$PressStartLayer/AnimationPlayer.seek(0.0)  # Réinitialise l'animation à son début
# warning-ignore:return_value_discarded
		get_tree().change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func _on_starting_screen_finished():
	$PressStartLayer/startingFixe.play()
	if $PressStartLayer/startingFixe.finished:
		$PressStartLayer/startingFixe.play()

# Cheat code
func cheat_code():
	if Input.is_action_pressed("ui_a") and Input.is_action_pressed("ui_b"):
		get_tree().change_scene_to_file("res://scenes/ui/abdelRunMenu.tscn")
