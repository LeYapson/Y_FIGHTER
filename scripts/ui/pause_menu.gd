extends Control

@onready var main = $"../"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_resume_pressed():
	main.pauseMenu()


func _on_quit_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/ui/TitleScreen.tscn")
#	get_tree().quit()


func _on_texture_button_pressed():
	get_tree().quit()
