extends Panel

func _on_select_pressed():
	# Changez vers la scène de jeu lorsque le bouton "Jouer" est pressé
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file("res://scenes/ui/selectCharacter.tscn")
