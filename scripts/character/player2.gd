extends basePerso

class_name Player2

func _ready():
	healthChanged.emit()
	staminaChanged.emit()
	animState.travel("anim/Idle")
	facingRight = false
	inputAttack = "attackP2"
	inputBlock = "blockP2"
	inputMoveLeft = "moveLeftP2"
	inputMoveRight = "moveRightP2"
	inputJump = "jumpP2"
	inputNull = "nullKey"
	enemy = "Player1"

func get_move_input(delta):
	
	var vy = velocity.y
	velocity.y = 0.0
	
	var input = Input.get_vector("nullKey", "nullKey", "moveRightP2", "moveLeftP2")
	var dir = Vector3(0, 0, -input.y)
	velocity = lerp(velocity, -dir * SPEED, ACCELERATION * delta)
	var vl = velocity * model.transform.basis
	animTree.set("parameters/IdleWalk/blend_position", vl.z/SPEED)
	velocity.y = vy
