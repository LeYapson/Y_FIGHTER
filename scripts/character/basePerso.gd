extends CharacterBody3D

class_name basePerso

signal healthChanged
signal staminaChanged

const SPEED = 5.0
const ACCELERATION = 4.0
const JUMP_VELOCITY = 5.0

@onready var model = $RootNode
@onready var animTree = $AnimationTree
@onready var animState = $AnimationTree.get("parameters/playback")

@export var maxHealth = 100
@onready var currentHealth: int = maxHealth

@export var maxStamina = 100.0
@onready var currentStamina: float = maxStamina

var attackeAnim = "CharacterArmature|Punch"
var deathAnim = "CharacterArmature|Death"
var hurtAnim = "CharacterArmature|HitReact"
var waveAnim = "CharacterArmature|Duck"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping = false
var lastFloor = true
var attackDamage = 10
var facingRight
var isAlive = true
var isInvulnerable = false

var enableControls = true


var inputAttack
var inputBlock
var inputMoveLeft
var inputMoveRight 
var inputJump
var inputNull

func _ready():
	healthChanged.emit()
	staminaChanged.emit()
	animState.travel("CharacterArmature|Idle")
	
func _physics_process(delta):
	if enableControls == true :
		velocity.y += -gravity * delta
		if isAlive == true:
			get_move_input(delta)
			move_and_slide()
			rotate_character()
			jump()
			if Input.is_action_just_pressed(inputAttack):
				attack()

			if Input.is_action_pressed(inputBlock):
				block()

			if !Input.is_action_pressed(inputBlock) && currentStamina < maxStamina:
				isInvulnerable = false
				if currentStamina < maxStamina:
					currentStamina += 0.5
					staminaChanged.emit()
					
			
			if currentStamina <= 0 :
				isInvulnerable = false
				
		if currentHealth <=0:
#			isAlive = false
			animState.travel(deathAnim)

func get_move_input(delta):
	
	var vy = velocity.y
	velocity.y = 0.0
	
	var input = Input.get_vector("nullKey", "nullKey", inputMoveRight, inputMoveLeft)
	var dir = Vector3(0, 0, input.y)
	velocity = lerp(velocity, dir * SPEED, ACCELERATION * delta)
	var vl = velocity * model.transform.basis
	animTree.set("parameters/IdleWalkRun/blend_position", -vl.z/SPEED)
	velocity.y = vy
	
func rotate_character():
	if Input.is_action_pressed(inputMoveRight) && facingRight==false:
		model.rotate_y(-deg_to_rad(180))
		facingRight=true

	if Input.is_action_pressed(inputMoveLeft) && facingRight==true:
		model.rotate_y(deg_to_rad(180))
		facingRight=false

func jump():
	if is_on_floor() and Input.is_action_just_pressed(inputJump):
		jumping = true
		velocity.y = JUMP_VELOCITY
		animTree.set("parameters/conditions/jumping", true)
		animTree.set("parameters/conditions/grounded", false)
	if is_on_floor() and not lastFloor:
		jumping = false
		animTree.set("parameters/conditions/jumping", false)
		animTree.set("parameters/conditions/grounded", true)
	if not is_on_floor() and not jumping:
		animState.travel("CharacterArmature|Jump_Idle")
		animTree.set("parameters/conditions/grounded", false)
	lastFloor = is_on_floor()
	
func attack():
	$TimerAttackHitbox.start()
	get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = false
	animState.travel(attackeAnim)

func block():
	if currentStamina > 0 :
		isInvulnerable = true
		currentStamina -= 1
		staminaChanged.emit()


func hurt(damages):
	if isInvulnerable == true:
		currentHealth -= damages / 2
		currentStamina -= 10
		print(damages / 2)
		staminaChanged.emit()
		healthChanged.emit()
		animState.travel(hurtAnim)
	else:
		currentHealth -= damages
		print(damages)
		healthChanged.emit()
		animState.travel(hurtAnim)
		
func heal():
	currentHealth = maxHealth
	currentStamina = maxStamina
	hurt(0)
	staminaChanged.emit()
	healthChanged.emit()

func _on_hitbox_body_entered(body):
	if body.is_in_group("Player2") and body.has_method("hurt"):
		body.hurt(attackDamage)

func _on_timer_attack_hitbox_timeout():
	get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = true
