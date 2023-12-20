extends TextureProgressBar

@export var player1 : Player1

func _ready():
	player1.healthChanged.connect(update)
	update()

func update():
	value = player1.currentHealth * 100 / player1.maxHealth
