extends basePerso

class_name Player2

func _ready():
	healthChanged.emit()
	staminaChanged.emit()
	animState.travel("CharacterArmature|Idle")
	facingRight = false
