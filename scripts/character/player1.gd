extends basePerso

class_name Player1

func _ready():
	healthChanged.emit()
	staminaChanged.emit()
	animState.travel("CharacterArmature|Idle")
	get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = true
	facingRight = true
	inputAttack = "attackP1"
	inputBlock = "blockP1"
	inputMoveLeft = "moveLeftP1"
	inputMoveRight = "moveRightP1"
	inputJump = "jumpP1"
	inputNull = "nullKey"
