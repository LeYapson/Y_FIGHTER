extends TextureProgressBar

@export var player2: CharacterBody3D

func _ready():
	player2.healthChanged.connect(update)
	update()

func update():
	value = player2.currentHealth * 100 / player2.maxHealth
