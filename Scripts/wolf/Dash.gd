extends State

@export var wolf: Wolf
var dash_direction = Vector3.ZERO
var dash_speed = 100

func enter():
	wolf.animation_player.play("dash")
	dash_direction = (wolf.player.global_position - wolf.global_position).normalized()
	
func physics_update(delta):
	wolf.rotation.y = lerp_angle(wolf.rotation.y, atan2(-dash_direction.x, -dash_direction.z), delta * 2.5)
	
#chamada no frame da animacao
func _on_dash():
	wolf.velocity = dash_direction * dash_speed
	
func _on_animation_player_animation_finished(anim_name):
	Transitioned.emit(self, "chase")
