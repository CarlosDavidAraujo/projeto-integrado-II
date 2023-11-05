extends State

@export var player: Player
@onready var animation_player = $"../../Pivot/AnimationPlayer"
@onready var attack_delay = $"../../AttackDelay"
@onready var hitbox = $"../../Pivot/rig/Skeleton3D/WeaponAtachment/Hitbox"

var attack_count = 1
var can_chain_attack = true
var animation: String
var attack_animations = ["Aanim attack 01","Aanim attack 02","Aanim heavy attack" ]
		
func physics_update(delta: float):
	light_attack()
	heavy_attack()
	if player.isAttacking:
		player.look_at_mouse_position()
	if player.isDashing:
		on_attack_finished()

#atraso para nao corta a animacao dos ataques encadeados cedo demais, 
#isso é uma gambiarra, deve ter um jeito correto de fazer isso	
func _on_attack_delay_timeout(): 
	can_chain_attack = true
	
#Se nao atacar novamente ates da animacao terminar reseta o combo
func _on_animation_player_animation_finished(anim_name):
	if anim_name in attack_animations:
		on_attack_finished()

func light_attack():
	if Input.is_action_just_pressed("light_attack") and not player.isDashing and can_chain_attack:
		player.damage = 5.0
		can_chain_attack = false
		player.isAttacking = true
		hitbox.monitoring = true
		attack_delay.start()
		animation = "Aanim attack 0" + str(attack_count)
		animation_player.play(animation, 0.2)
		attack_count += 1
		if attack_count > 2:
			attack_count = 1
			
func heavy_attack():
	if Input.is_action_just_pressed("heavy_attack") and not player.isDashing and can_chain_attack:
		player.damage = 10
		can_chain_attack = false
		player.isAttacking = true
		hitbox.monitoring = true
		animation_player.speed_scale = 1.3
		animation_player.play("Aanim heavy attack")

func on_attack_finished():
	player.isAttacking = false
	attack_count = 1
	can_chain_attack = true
	hitbox.monitoring = false
	animation_player.speed_scale = 1
