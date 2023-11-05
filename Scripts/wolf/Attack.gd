extends State

@export var wolf: Wolf
@onready var animation_player = $"../../espirito_02/AnimationPlayer"

func enter():
	$"../../AttackHitBox".monitoring = true
	
func exit():
	$"../../AttackHitBox".monitoring = false
	$"../../AttackHitBox/CollisionShape3D".disabled = true

func physics_update(delta: float):
	animation_player.play("dash")
	var direction = (wolf.player.global_position - wolf.global_position).normalized()
	wolf.rotation.y = lerp_angle(wolf.rotation.y, atan2(-direction.x, -direction.z), delta * 5)
	wolf.velocity = Vector3.ZERO
	if not wolf.is_in_melee_range:
		Transitioned.emit(self, "chase")
		
func _on_attack_hit_box_body_entered(body):
	if body.is_in_group("player"):
		wolf.player.hurt(wolf.damage)
