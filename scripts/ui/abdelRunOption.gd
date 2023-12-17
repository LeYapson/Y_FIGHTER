extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://scenes/ui/abdelRunMenu.tscn")


func _on_key_biding_pressed():
	pass # Replace with function body.
