extends CharacterBody3D

class_name Player3

signal hc

const SPEED = 5.0
const ACCELERATION = 4.0
const JUMP_VELOCITY = 5.0

@onready var model = $RootNode
@onready var anim_tree = $AnimationTree
@onready var anim_state = $AnimationTree.get("parameters/playback")

@export var maxHealth = 100
@onready var currentHealth: int = maxHealth

@onready var maxStamina = 100.0
@onready var currentStamina: float = maxStamina

var attack_anim = "CharacterArmature|Dagger_Attack"
var death_anim = "CharacterArmature|Death"
var hurt_anim = "CharacterArmature|RecieveHit"
var wave_anim = "CharacterArmature|Duck"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping = false
var last_floor = true
var attack_damage = 10
var facing_right = false
var is_alive = true
var is_invulnerable = false

var enable_controls = true

func _ready():
	hc.emit()
	get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = true
	anim_state.travel("CharacterArmature|Idle")
	
func _physics_process(delta):
	if enable_controls == true :
		velocity.y += -gravity * delta
		if is_alive == true:
			get_move_input(delta)
			move_and_slide()
			rotate_character()
			jump()
			if Input.is_action_just_pressed("attack_p2"):
				attack()

			if Input.is_action_pressed("block_p2"):
				block()

			if !Input.is_action_pressed("block_p2") && currentStamina < maxStamina:
				is_invulnerable = false
				if currentStamina < maxStamina:
					currentStamina += 0.5
			
			if currentStamina <= 0 :
				is_invulnerable = false
				
		if currentHealth <=0:
#			is_alive = false
			anim_state.travel(death_anim)

func get_move_input(delta):
	
	var vy = velocity.y
	velocity.y = 0.0
	
	var input = Input.get_vector("nullKey", "nullKey", "move_right_p2", "move_left_p2")
	var dir = Vector3(0, 0, -input.y)
	velocity = lerp(velocity, -dir * SPEED, ACCELERATION * delta)
	var vl = velocity * model.transform.basis
	anim_tree.set("parameters/IdleWalkRun/blend_position", vl.z/SPEED)
	velocity.y = vy
	
func rotate_character():
	if Input.is_action_pressed("move_right_p2") && facing_right==false:
		model.rotate_y(-deg_to_rad(180))
		facing_right=true

	if Input.is_action_pressed("move_left_p2") && facing_right==true:
		model.rotate_y(deg_to_rad(180))
		facing_right = false

func jump():
	if is_on_floor() and Input.is_action_just_pressed("jump_p2"):
		jumping = true
		velocity.y = JUMP_VELOCITY
		anim_tree.set("parameters/conditions/jumping", true)
		anim_tree.set("parameters/conditions/grounded", false)
	if is_on_floor() and not last_floor:
		jumping = false
		anim_tree.set("parameters/conditions/jumping", false)
		anim_tree.set("parameters/conditions/grounded", true)
	if not is_on_floor() and not jumping:
		anim_state.travel("CharacterArmature|Jump_Idle")
		anim_tree.set("parameters/conditions/grounded", false)
	last_floor = is_on_floor()
	
func attack():
	$TimerAttackHitbox.start()
	get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = false
	anim_state.travel(attack_anim)

func block():
	if currentStamina > 0 :
		is_invulnerable = true
		currentStamina -= 1


func hurt(damages):
	if is_invulnerable == true:
		currentHealth -= damages / 2
		hc.emit()
	else:
		currentHealth -= damages
		hc.emit()
		anim_state.travel(hurt_anim)
		
func heal():
	currentHealth = maxHealth
	hurt(0)
	hc.emit()

func _on_hitbox_body_entered(body):
	if body.is_in_group("Player1") and body.has_method("hurt"):
		body.hurt(attack_damage)

func _on_timer_attack_hitbox_timeout():
	get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = true
