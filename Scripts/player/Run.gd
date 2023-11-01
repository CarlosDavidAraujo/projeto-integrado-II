extends State

@export var player: Player
var target_velocity = Vector3.ZERO

func physics_update(delta: float):
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
	if direction != Vector3.ZERO: #se estiver se movendo
		direction = direction.normalized()
		$"../../Pivot".look_at(player.global_position + direction, Vector3.UP)
	else: #se nao estiver se movendo muda para o estado idle
		Transitioned.emit(self, "idle")
	
	# quando esta atacando nao excuta a animacao de corrida e desacelera
	if  player.isAttacking:	
		player.speed = 10
	else:
		player.speed = 30
		player.animation_player.play("Aanim Run cycle") 
		
		
	#Movimentando o personagem
	target_velocity.x = direction.x * player.speed
	target_velocity.z = direction.z * player.speed
	player.velocity = target_velocity

#muda para estado de dash quando aciona a tecla de dash
func state_input(event: InputEvent):
	if event.is_action_pressed("dash")  and player.canDash:
		Transitioned.emit(self, "dash")
