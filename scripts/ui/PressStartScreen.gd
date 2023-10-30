extends Control

func _ready():
	await get_tree().create_timer(3.0).timeout
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
	$PressStartLayer/LoadingScreen.hide()
	# Ici, vous pouvez ajouter du code supplémentaire pour initialiser d'autres éléments de votre scène si nécessaire
