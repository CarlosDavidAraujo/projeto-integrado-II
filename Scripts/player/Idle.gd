extends State

@export var player: Player
@onready var animation = $"../../Pivot/AnimationPlayer"
	
func physics_update(delta: float):
	player.velocity = Vector3.ZERO
	
	if not player.isAttacking:
		animation.play("Aanim Idle cycle 02")
	
	if player.isMoving():
		Transitioned.emit(self, "run")
		
#muda para estado de dash quando aciona a tecla de dash ou para corrida quando apertar outra tecla
func state_input(event: InputEvent):
	if event.is_action_pressed("dash") and player.canDash:
		Transitioned.emit(self, "dash")

