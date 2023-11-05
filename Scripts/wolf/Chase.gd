extends State

@export var wolf: Wolf
@onready var animation_player = $"../../espirito_02/AnimationPlayer"

func enter():
	animation_player.play("run")
	
func physics_update(delta: float):
	var direction = (wolf.player.global_position - wolf.global_position).normalized()
	wolf.rotation.y = lerp_angle(wolf.rotation.y, atan2(-direction.x, -direction.z), delta * 2.5)
	wolf.velocity = direction * wolf.speed
	
	if wolf.is_in_melee_range:
		Transitioned.emit(self, "attack")
		
func _on_combat_zone_body_exited(body):
	if body.is_in_group("player"):
		Transitioned.emit(self, "idle")
	
