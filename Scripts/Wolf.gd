extends CharacterBody3D
class_name Enemy
signal healthChanged

@export var player: Player
@export var maxHealth = 30
@onready var currentHealth: int = maxHealth
@onready var wolf_anim = $espirito_02/AnimationPlayer

var runSpeed = 15
var dashSpeed = 300
var isDashing = false
var isDashRecharging = false
var dashDirection = Vector3.ZERO
var isDead = false

func _physics_process(delta):
	var currentSpeed = runSpeed
	var distanceToPlayer = position.distance_to(player.global_position)
	
	#Executando a dash
	if distanceToPlayer > 30 and not isDashRecharging and not isDead:
		wolf_anim.speed_scale = 2
		isDashing = true
		currentSpeed = dashSpeed
		dashDirection = (player.global_position - position).normalized()
		wolf_anim.play("dash")
		
	#Correndo
	if not isDashing and distanceToPlayer > 12 and not isDead:
		wolf_anim.speed_scale = 1.3
		wolf_anim.play("run")
	
	#Parando
	if distanceToPlayer <= 12 or isDead:
		currentSpeed = 0
		wolf_anim.speed_scale = 1
		wolf_anim.play("idle")
		
	velocity = dashDirection * currentSpeed if isDashing else (player.global_position - position).normalized() * currentSpeed
	move_and_slide()
	
	# Mantém o lobo olhando para o player
	if not isDead:
		if isDashing:
			look_at(position + dashDirection, Vector3(0, 1, 0))
		else:
			look_at(player.global_position)

func hurt():
	currentHealth -= 3
	if currentHealth <= 0:
		isDead = true
	healthChanged.emit()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dash":
		isDashing = false
		isDashRecharging = true
		dashDirection = Vector3.ZERO
