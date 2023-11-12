extends State

@export var wolf: Wolf
@onready var animation_player = $"../../Pivot/AnimationPlayer"

var jump_speed = 50 

func enter():
	animation_player.play("pulo")
		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "pulo":
		wolf.can_evade = false
		wolf.evasion_cd.start()
		Transitioned.emit(self, "chase")

#chamado no momento certo da animacao
func _on_evasion():
	# Obtém a direção em que o lobo está virado
	var facing_direction = wolf.global_transform.basis.z.normalized()
	wolf.velocity = facing_direction * jump_speed
