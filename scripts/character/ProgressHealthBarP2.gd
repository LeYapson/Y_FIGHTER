extends TextureProgressBar

@export var player2 : Player2

func _ready():
	player2.healthChanged.connect(update)
	update()

func update():
	value = player2.current_health * 100 / player2.max_health
