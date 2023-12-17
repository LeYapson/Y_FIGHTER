extends Panel

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/selectMap.tscn")
