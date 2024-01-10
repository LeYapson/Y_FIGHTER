extends Node3D

class_name Player2

signal healthChanged

@onready var animation = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var anim_state = $AnimationTree.get("parameters/playback")

var hurt_anim = "CharacterArmature|RecieveHit"
var death_anim = "CharacterArmature|Death"

@export var max_health = 100
@onready var current_health: int = max_health

var enable_controls = true

# Called when the node enters the scene tree for the first time.
func _ready():
	healthChanged.emit()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_health <= 0:
		anim_state.travel(death_anim)
		$CollisionShape3D.disabled = true

func hurt(damages):
	anim_state.travel(hurt_anim)
	current_health -= damages
	healthChanged.emit()

func heal():
	current_health = max_health
	healthChanged.emit()
#
#func set_idle_anim():
#	animation.travel("CharacterArmature|Idle")
