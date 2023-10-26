extends CharacterBody3D
class_name Enemy
signal healthChanged

@export var player: Player
@export var maxHealth = 30
@onready var currentHealth: int = maxHealth
@onready var wolf_anim = $espirito_02/AnimationPlayer

var currentSpeed = 0
var runSpeed = 15
var dashSpeed = 50
var isDashing = false
var isDashRecharging = false
var dashDirection = Vector3.ZERO
var isDead = false
var playerDistance: float = 100.0
var playerPosition: Vector3 = Vector3.ZERO

func _physics_process(delta):
	playerDistance = position.distance_to(player.global_position)
	playerPosition = (player.global_position - position).normalized()

	if not isDead:
		dash()
		run()
		if isDashing:
			look_at(position + dashDirection, Vector3(0, 1, 0))
		else:
			look_at(player.global_position)
		
	stop()
	move_and_slide()
	
func hurt():
	currentHealth -= 3
	if currentHealth <= 0:
		isDead = true
	healthChanged.emit()

func dash():
	if playerDistance > 30.0 and not isDashRecharging:
		isDashing = true
		velocity = playerPosition * dashSpeed
		wolf_anim.speed_scale = 1.3
		wolf_anim.play("dash")
		
func run():
	print(isDashing, playerDistance)
	if not isDashing and playerDistance > 12.0:
		velocity = playerPosition * runSpeed
		wolf_anim.speed_scale = 1.3
		wolf_anim.play("run")

func stop():
	if playerDistance <= 12.0 or isDead:
		velocity = Vector3.ZERO
		wolf_anim.speed_scale = 1
		wolf_anim.play("idle")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dash":
		isDashing = false
		isDashRecharging = true

