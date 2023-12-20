extends TextureProgressBar

@export var player1 : Player1

func _ready():
	player1.healthChanged.connect(update)
	update()

func update():
	value = player1.current_health * 100 / player1.max_health
