extends basePerso

class_name Player1

func _ready():
	healthChanged.emit()
	staminaChanged.emit()
	animState.travel("anim/Idle")
	facingRight = true
	inputAttack = "attackP1"
	inputBlock = "blockP1"
	inputMoveLeft = "moveLeftP1"
	inputMoveRight = "moveRightP1"
	inputJump = "jumpP1"
	inputNull = "nullKey"
	enemy = "Player2"
	
func get_move_input(delta):
	
	var vy = velocity.y
	velocity.y = 0.0
	
	var input = Input.get_vector("nullKey", "nullKey", inputMoveRight, inputMoveLeft)
	var dir = Vector3(0, 0, input.y)
	velocity = lerp(velocity, dir * SPEED, ACCELERATION * delta)
	var vl = velocity * model.transform.basis
	animTree.set("parameters/IdleWalk/blend_position", -vl.z/SPEED)
	velocity.y = vy
