extends State

@export var wolf: Wolf
@onready var animation_player = $"../../Pivot/AnimationPlayer"
@onready var attack_zone = $"../../AttackZone"

func enter():
	animation_player.play("idle")
	
func physics_update(delta):
	if wolf:
		wolf.velocity = Vector3.ZERO
	
func _on_combat_zone_body_entered(body):
	if body.is_in_group("player"):
		Transitioned.emit(self, "chase")
