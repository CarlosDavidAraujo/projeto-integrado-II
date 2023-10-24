extends CharacterBody3D

@export var speed = 14
@onready var animation_player = $Pivot/personagem_idle/AnimationPlayer
@onready var hitbox = $Pivot/personagem_idle/rig/Skeleton3D/WeaponAttachment/HitBox
var target_velocity = Vector3.ZERO
var isAttacking = false
var isMoving = false

#Controla as animações
func _updateAnimation():
	if isAttacking: return 
	if isMoving: 
		animation_player.play("Aanim Run cycle")
		return
	animation_player.play("Aanim Idle cycle")

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
	
	#Controle de direção do personagem
	if direction != Vector3.ZERO:
		isMoving = true
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
	else:
		isMoving = false

	#Controle de ataque leve
	if Input.is_action_just_pressed("light_attack") and not isAttacking:
		isAttacking = true
		animation_player.play("Aanim attack 01",0.2)
		await animation_player.animation_finished
		isAttacking = false
		
	#Controle de ataque pesado
	if Input.is_action_just_pressed("heavy_attack") and not isAttacking:
		isAttacking = true
		animation_player.play("Aanim attack_02",0.2)
		await animation_player.animation_finished
		isAttacking = false
	
	#Movimentando o personagem
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	velocity = target_velocity
	
	move_and_slide()
	_updateAnimation()
	
func _on_hitbox_body_entered(body):
	print(body)
	if body.has_method("hurt"):
		body.hurt()



