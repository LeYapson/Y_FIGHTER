extends Control
var progress = []
var sceneName
var scene_load_status = 0
var cooldown = 1.0

func _ready():
	sceneName = "res://scenes/games/MTPFIKA.tscn"
	ResourceLoader.load_threaded_request(sceneName)
	
func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName,progress)
	$VideoStreamPlayer.play()
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(newScene)
