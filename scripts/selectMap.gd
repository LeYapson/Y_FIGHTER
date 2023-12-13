extends Panel

@onready var worlds: Array = [$selectMapLayer/MenuMap/mapIcon, $selectMapLayer/MenuMap/mapIcon2, $selectMapLayer/MenuMap/mapIcon3, $selectMapLayer/MenuMap/mapIcon4, $selectMapLayer/MenuMap/mapIcon5, $selectMapLayer/MenuMap/mapIcon6, $selectMapLayer/MenuMap/mapIcon7, $selectMapLayer/MenuMap/mapIcon8, $selectMapLayer/MenuMap/mapIcon9, $selectMapLayer/MenuMap/mapIcon10, $selectMapLayer/MenuMap/mapIcon11, $selectMapLayer/MenuMap/mapIcon12, $selectMapLayer/MenuMap/mapIcon13, $selectMapLayer/MenuMap/mapIcon14, $selectMapLayer/MenuMap/mapIcon15]
var current_world: int = 0

func _ready():
	$selectMapLayer/MenuMap/playerIcon.global_position = worlds[current_world].global_position
	
func _input(event):
	if event.is_action_pressed("ui_left") and current_world > 0:
		current_world -= 1
		$selectMapLayer/MenuMap/playerIcon.global_position = worlds[current_world].global_position
	if event.is_action_pressed("ui_right") and current_world < worlds.size() -1:
		current_world += 1
		$selectMapLayer/MenuMap/playerIcon.global_position = worlds[current_world].global_position

func _on_select_pressed():
	# Changez vers la scène de jeu lorsque le bouton "Jouer" est pressé
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file("res://scenes/ui/selectCharacter.tscn")
