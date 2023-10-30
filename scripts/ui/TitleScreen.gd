extends Panel

func _ready():
	# Ici, vous pouvez initialiser des choses comme la musique de fond, etc.
	pass

func _on_Play_pressed():
	# Changez vers la scène de jeu lorsque le bouton "Jouer" est pressé
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file("res://scenes/game/.tscn")

func _on_Training_pressed():
	# Changez vers la scène d'options lorsque le bouton "Options" est pressé
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file("res://scenes/game/TrainingMap.tscn")

func _on_Quit_pressed():
	# Quittez le jeu lorsque le bouton "Quitter" est pressé
	get_tree().quit()
