extends TextureProgressBar

@export var player2: Player2

func _ready():
	player2.staminaChanged.connect(update)
	update()

func update():
	value = player2.currentStamina * 100.0 / player2.maxStamina

