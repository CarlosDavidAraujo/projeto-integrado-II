extends State

@export var player: Player
@onready var animation = $"../../Pivot/AnimationPlayer"
#SOM
@onready var timer = $"../../Timer"
@onready var walk = $"../../walk"
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
	else: #se nao estiver se movendo muda para o estado idle
		Transitioned.emit(self, "idle")
		
	
	# quando esta atacando desacelera e nao excuta a animacao de corrida
	if  player.isAttacking:	
		player.speed = 10
	else:
		player.speed = 30
		animation.play("Aanim Run cycle")
	
		player.look_at_move_direction()
				
	#Movimentando o personagem
	target_velocity.x = direction.x * player.speed
	target_velocity.z = direction.z * player.speed
	player.velocity = target_velocity
	
func _play_footstep_audio() -> void:
	walk.pitch_scale = randf_range(.8,1.2)
	walk.play()
	
	

#muda para estado de dash quando aciona a tecla de dash
func state_input(event: InputEvent):
	if event.is_action_pressed("dash") and player.canDash:
		Transitioned.emit(self, "dash")
