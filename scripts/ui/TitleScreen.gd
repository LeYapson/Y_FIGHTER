extends Panel

func _on_Play_pressed():
		get_tree().change_scene_to_file("res://scenes/games/MTPFIKA.tscn")

func _on_Training_pressed():
	# Changez vers la scène d'options lorsque le bouton "Options" est pressé
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file("res://scenes/game/TrainingMap.tscn")

func _on_Quit_pressed():
	# Quittez le jeu lorsque le bouton "Quitter" est pressé
	get_tree().quit()
