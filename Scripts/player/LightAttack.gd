extends State

@export var player: Player
@onready var hitbox = $"../../Pivot/rig/Skeleton3D/WeaponAtachment/Hitbox"

func physics_update(delta: float):
		#Controle de ataque leve
	if Input.is_action_just_pressed("light_attack") and not player.isDashing:
		player.isAttacking = true
		player.animation_player.play("Aanim attack 01",0.2)
		hitbox.monitoring = true
		
	#Controle de ataque pesado
	if Input.is_action_just_pressed("heavy_attack") and not player.isDashing:
		player.isAttacking = true
		player.animation_player.play("Aanim attack_02",0.2)
		hitbox.monitoring = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Aanim attack 01" or anim_name == "Aanim attack_02":
		player.isAttacking = false
