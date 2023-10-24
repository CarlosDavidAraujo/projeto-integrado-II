extends CharacterBody3D

@export var speed = 14
@onready var animation_player = $Pivot/personagem_idle/AnimationPlayer
var target_velocity = Vector3.ZERO
var isAttacking = false

func _physics_process(delta):
	#Controle de movimento
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	#Animaçao do movimento
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		if not isAttacking:
			animation_player.play("Aanim Run cycle")
	else:
		if not isAttacking:
			animation_player.play("Aanim Idle cycle")

	#Animacao de ataque
	if Input.is_action_just_pressed("light_attack") and not isAttacking:
		isAttacking = true
		animation_player.play("Aanim attack 01")
		await animation_player.animation_finished
		isAttacking = false
	
	#Movimentando o personagem
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	velocity = target_velocity
	move_and_slide()


