extends CharacterBody3D

class_name Player1

signal healthChanged

const SPEED = 5.0
const ACCELERATION = 4.0
const JUMP_VELOCITY = 5.0

@onready var model = $RootNode
@onready var anim_tree = $AnimationTree
@onready var anim_state = $AnimationTree.get("parameters/playback")

@export var max_health = 100
@onready var current_health: int = max_health
var attack_anim = "CharacterArmature|Punch"
var death_anim = "CharacterArmature|Death"
var hurt_anim = "CharacterArmature|HitReact"
var wave_anim = "CharacterArmature|Duck"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping = false
var last_floor = true
var attack_damage = 33
var facing_right = false
var is_alive = true
var is_invulnerable = false
var stamina = 100

var enable_controls = true

func _ready():
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
			if Input.is_action_just_pressed("attack_p1"):
				attack()

			if Input.is_action_pressed("block_p1"):
				block()
			
			print(is_invulnerable)
			print(stamina)
			if !Input.is_action_pressed("block_p1") && stamina < 101:
				is_invulnerable = false
				if stamina < 100:
					stamina += 0.5
			
			if stamina <= 0 :
				is_invulnerable = false
				
			wave()
		if current_health <=0:
			is_alive = false
			anim_state.travel(death_anim)
	#		set_process_input(false)
	#		$CollisionShape3D.disabled = true

func get_move_input(delta):
	
	var vy = velocity.y
	velocity.y = 0.0
	
	var input = Input.get_vector("nullKey", "nullKey", "move_left_p1", "move_right_p1")
	var dir = Vector3(0, 0, input.y)
	velocity = lerp(velocity, dir * SPEED, ACCELERATION * delta)
	var vl = velocity * model.transform.basis
	anim_tree.set("parameters/IdleWalkRun/blend_position", -vl.z/SPEED)
	velocity.y = vy
	
func rotate_character():
	if Input.is_action_pressed("move_right_p1") && facing_right==false:
		model.rotate_y(deg_to_rad(180))
		facing_right=true

	if Input.is_action_pressed("move_left_p1") && facing_right==true:
		model.rotate_y(-deg_to_rad(180))
		facing_right=false

func jump():
	if is_on_floor() and Input.is_action_pressed("jump_p1"):
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
	if stamina > 0 :
		is_invulnerable = true
		stamina -= 1


func hurt(damages):
	if is_invulnerable == true:
		current_health -= damages / 2
		healthChanged.emit()
	else:
		current_health -= damages
		healthChanged.emit()
		anim_state.travel(hurt_anim)
		
func heal():
	current_health = max_health
	healthChanged.emit()

func wave():
	if Input.is_action_just_pressed("wave_p1") and jumping==false:
		anim_state.travel(wave_anim)
		get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = true

func _unhandled_input(event):
	pass

func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy") and body.has_method("hurt"):
		body.hurt(attack_damage)

func _on_timer_attack_hitbox_timeout():
	get_node("RootNode/CharacterArmature/Skeleton3D/ArmAttachment/Hitbox/ArmCollisionShape").disabled = true
