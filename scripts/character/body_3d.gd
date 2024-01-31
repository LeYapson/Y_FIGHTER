extends CharacterBody3D

class_name Player2

signal healthChanged

const SPEED = 5.0
const ACCELERATION = 4.0
const JUMP_VELOCITY = 5.0

@onready var model = $RootNode
@onready var animTree = $AnimationTree
@onready var animState = $AnimationTree.get("parameters/playback")

@export var maxHealth = 100
@onready var currentHealth: int = maxHealth

@onready var maxStamina = 100.0
@onready var currentStamina: float = maxStamina

var attackAnim = "anim_Hit"
#var deathAnim = "CharacterArmature|Death"
#var hurtAnim = "CharacterArmature|HitReact"
#var waveAnim = "CharacterArmature|Duck"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping = false
var lastFloor = true
var attackDamage = 10
var facingRight = false
var isAlive = true
var isInvulnerable = false

var enableControls = true

func _ready():
	healthChanged.emit()
#	get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = true
	animState.travel("anim/Idle")
	
func _physics_process(delta):
	if enableControls == true :
		velocity.y += -gravity * delta
		if isAlive == true:
			get_move_input(delta)
			move_and_slide()
			rotate_character()
			jump()
			if Input.is_action_just_pressed("attack_p2"):
				attack()

			if Input.is_action_pressed("block_p2"):
				block()

			if !Input.is_action_pressed("block_p2") && currentStamina < maxStamina:
				isInvulnerable = false
				if currentStamina < maxStamina:
					currentStamina += 0.5
			
			if currentStamina <= 0 :
				isInvulnerable = false
				
		if currentHealth <=0:
			pass
#			isAlive = false
#			animState.travel(deathAnim)

func get_move_input(delta):
	
	var vy = velocity.y
	velocity.y = 0.0
	
	var input = Input.get_vector("nullKey", "nullKey", "move_right_p2", "move_left_p2")
	var dir = Vector3(0, 0, -input.y)
	velocity = lerp(velocity, -dir * SPEED, ACCELERATION * delta)
	var vl = velocity * model.transform.basis
	animTree.set("parameters/IdleWalk/blend_position", vl.z/SPEED)
	velocity.y = vy
	
func rotate_character():
	if Input.is_action_pressed("move_right_p2") && facingRight==false:
		model.rotate_y(-deg_to_rad(180))
		facingRight=true

	if Input.is_action_pressed("move_left_p2") && facingRight==true:
		model.rotate_y(deg_to_rad(180))
		facingRight=false

func jump():
	if is_on_floor() and Input.is_action_just_pressed("jump_p2"):
		jumping = true
		velocity.y = JUMP_VELOCITY
		animTree.set("parameters/conditions/jumping", true)
	if is_on_floor() and not lastFloor:
		jumping = false
		animTree.set("parameters/conditions/jumping", false)
	lastFloor = is_on_floor()
	
func attack():
#	$TimerAttackHitbox.start()
#	get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = false
	animState.travel(attackAnim)

func block():
	if currentStamina > 0 :
		isInvulnerable = true
		currentStamina -= 1


func hurt(damages):
	if isInvulnerable == true:
		currentHealth -= damages / 2
		print(damages / 2)
		healthChanged.emit()
#		animState.travel(hurtAnim)
	else:
		currentHealth -= damages
		print(damages)
		healthChanged.emit()
#		animState.travel(hurtAnim)
		
func heal():
	currentHealth = maxHealth
	hurt(0)
	healthChanged.emit()

func _on_hitbox_body_entered(body):
	pass
#	if body.has_method("hurt"):
	
#		 

func _on_timer_attack_hitbox_timeout():
	pass
#	get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = true




func _on_area_3d_body_entered(body):
	if body.is_in_group("Player1") and body.has_method("hurt"):
		body.hurt(attackDamage)
