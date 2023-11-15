extends CharacterBody3D
class_name Enemy
signal healthChanged

const SPEED = 20

var target = null
@export var targetPath : NodePath
@export var attack_range: float

func _ready():
	target = get_node(targetPath)
	healthChanged.emit()

@export var maxHealth = 30
@onready var currentHealth: int = maxHealth
@onready var wolf_anim = $espirito_02/AnimationPlayer
@onready var nav_agent = $NavigationAgent3D


#var currentSpeed = 0
#var runSpeed = 15
#var dashSpeed = 50
#var isDashing = false
#var isDashRecharging = false
#var dashDirection = Vector3.ZERO
var isDead = false
#var playerDistance: float = 100.0
#var playerPosition: Vector3 = Vector3.ZERO

func _chase(delta):
	velocity = Vector3.ZERO
	nav_agent.set_target_position(target.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	look_at(Vector3(target.global_position.x,target.global_position.y,target.global_position.z), Vector3.UP)
	move_and_slide()

func _is_target_in_range():
	return global_position.distance_to(target.global_position) < attack_range

func _is_moving():
	return !(velocity.x == 0 && velocity.z == 0)

#func _physics_process(delta):
#	playerDistance = position.distance_to(player.global_position)
#	playerPosition = (player.global_position - position).normalized()
#
#	if not isDead:
#		dash()
#		run()
#
#		if isDashing:
#			#na dash pula na direção atual
#			look_at(position + dashDirection, Vector3(0, 1, 0))
#		else:
#			#suaviza a rotacao do lobo quando esta correndo
#			rotation.y = lerp_angle(rotation.y, atan2(-playerPosition.x, -playerPosition.z), delta * 2.5)
#
#	stop()
#	move_and_slide()
	
func hurt():
	currentHealth -= 3
	if currentHealth <= 0:
		isDead = true
	healthChanged.emit()

#func dash():
#	if playerDistance > 30.0 and not isDashRecharging:
#		isDashing = true
#		velocity = playerPosition * dashSpeed
#		wolf_anim.speed_scale = 1.3
#		wolf_anim.play("dash")
#
#func run():
#	print(isDashing, playerDistance)
#	if not isDashing and playerDistance > 12.0:
#		velocity = playerPosition * runSpeed
#		wolf_anim.speed_scale = 1.3
#		wolf_anim.play("run")
#
#func stop():
#	if playerDistance <= 12.0 or isDead:
#		velocity = Vector3.ZERO
#		wolf_anim.speed_scale = 1
#		wolf_anim.play("idle")

#func _on_animation_player_animation_finished(anim_name):
#	if anim_name == "dash":
#		isDashing = false
#		isDashRecharging = true

