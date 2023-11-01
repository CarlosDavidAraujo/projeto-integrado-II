extends State

@export var player: Player

func physics_update(delta: float):
	player.velocity = Vector3.ZERO
	
	#so faz a animacao de idle se nao estiver atacando
	if not player.isAttacking:
		player.animation_player.play("Aanim Idle cycle")

#muda para estado de dash quando aciona a tecla de dash ou para corrida quando apertar outra tecla
func state_input(event: InputEvent):
	if event.is_action_pressed("dash") and player.canDash:
		Transitioned.emit(self, "dash")
	elif event.is_pressed():
		Transitioned.emit(self, "run")

