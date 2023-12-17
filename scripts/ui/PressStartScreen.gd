extends Control

# Cheat code
var sequence = [
	KEY_UP,
	KEY_UP,
	KEY_DOWN,
	KEY_DOWN,
	KEY_LEFT,
	KEY_RIGHT,
	KEY_LEFT,
	KEY_RIGHT,
	KEY_B,
	KEY_A
]
var sequence_index = 0

func cheat_code(event):
	print("InputEventKeyHello")
	if event.type == InputEventKey and event.pressed:
		if event.scancode == sequence[sequence_index]:
			sequence_index += 1
			print(sequence_index)
			if sequence_index == sequence.size():
				get_tree().change_scene_to_file("res://scenes/ui/abdelRunMenu.tscn")
				sequence_index = 0
		else:
			sequence_index = 0

func _ready():
	set_process_input(true)
	$PressStartLayer/AnimationPlayer.play("FadeInFadeOut")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		$PressStartLayer/AnimationPlayer.play("SlideOut")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SlideOut":
		$PressStartLayer/AnimationPlayer.seek(0.0)  # Réinitialise l'animation à son début
# warning-ignore:return_value_discarded
		get_tree().change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func _on_Timer_timeout():
	pass
	# Ici, vous pouvez ajouter du code supplémentaire pour initialiser d'autres éléments de votre scène si nécessaire
	
