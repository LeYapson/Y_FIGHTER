extends TextureProgressBar

@export var player1: Player1

func _ready():
	player1.staminaChanged.connect(update)
	update()

func update():
	value = player1.currentStamina * 100.0 / player1.maxStamina

