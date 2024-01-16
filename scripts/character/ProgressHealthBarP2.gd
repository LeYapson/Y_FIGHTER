extends TextureProgressBar

@export var player2 : Player2

func _ready():
	player2.hc.connect(update)
	update()



func update():
	value = player2.currentHealth * 100 / player2.maxHealth
