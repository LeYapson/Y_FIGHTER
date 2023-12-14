@tool
extends Control
@export var world_index: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if Engine.is_editor_hint():
	#	$Label.set_position(Vector2(285,-368))
	#	$Label.text = world_name[world_index]
