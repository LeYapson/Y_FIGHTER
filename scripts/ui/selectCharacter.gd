extends Panel

func _on_texture_button_pressed() -> void:
	var loadingScreen = load("res://scenes/ui/load.tscn")
	get_tree().change_scene_to_packed(loadingScreen)
