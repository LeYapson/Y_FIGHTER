extends KinematicBody2D

var health = 1000
var speed = 400
var gravity = 1200
var jump_force = -400
var force = 10
# Vector2 pour stocker la vitesse actuelle du personnage
var velocity = Vector2.ZERO
var state_machine
var controls_enabled : bool = true

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	# Récupération de l'entrée de l'utilisateur
	var input_direction = Vector2.ZERO
	input_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Input.get_action_strength("ui_right"):
		$AnimatedSprite.flip_h = true
	if Input.get_action_strength("ui_left"):
		$AnimatedSprite.flip_h = false
	# Appliquer la force de gravité
	velocity.y += gravity * delta
	
	velocity.x = input_direction.x * speed
	if input_direction.x == 0:
		state_machine.travel("Idle")
	elif input_direction.x != 0:
		state_machine.travel("Run")
	
	# Handle light Side attack
	if Input.is_action_just_pressed("LightSideAttack"):
		state_machine.travel("LightSideAttack")
		return
	# Handle light Side attack
	if Input.is_action_just_pressed("LightDownAttack"):
		state_machine.travel("LightDownAttack")
		return
	# Handle heavy Down attack
	if Input.is_action_just_pressed("HeavyDownAttack"):
		state_machine.travel("HeavyDownAttack")
		return
	# Handle heavy Down attack
	if Input.is_action_just_pressed("HeavySideAttack"):
		state_machine.travel("HeavySideAttack")
		return

	# Gestion du saut
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
		state_machine.travel("Jump")
		return  # Ceci empêchera le code suivant de s'exécuter, ce qui signifie que l'animation "Jump" ne sera pas interrompue.
	
	# Déplacement du personnage en utilisant move_and_slide
	velocity = move_and_slide(velocity, Vector2.UP)

func attack():
	# Handle light_attack
	if Input.is_action_just_pressed("LightAttack"):
		print("the action work")
		state_machine.travel("LightAttack")
		print("animation played")
		return
	# Handle heavy attack
	if Input.is_action_just_pressed("HeavyAttack"):
		print("this one work also")
		state_machine.travel("HeavyDownAttack")
		print("animation played")
		return


# Méthode pour gérer les dégâts infligés au personnage
func take_damage(damage: int) -> void:
	health -= damage
	state_machine.travel("hurt")
	if health <= 0:
		die()


# Méthode pour gérer la mort du personnage
func die() -> void:
	controls_enabled = false
	state_machine.travel("die")

