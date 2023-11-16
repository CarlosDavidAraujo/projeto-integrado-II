extends CharacterBody3D
class_name Wolf
signal healthChanged

const SPEED = 20

var target = null
@export var targetPath : NodePath
@export var attack_range: float
@export var too_far: float
@export var player: Player

func _ready():
	target = get_node(targetPath)
	healthChanged.emit()

@export var maxHealth: float = 5000
@onready var currentHealth: int = maxHealth
@onready var wolf_anim = $Pivot/AnimationPlayer
@onready var nav_agent = $NavigationAgent3D
@onready var damageSFX = $damageSFX
@onready var cd = $StateMachine/cd

var is_cd_able = true

var can_dash = true

var init = false
var isDead = false

func start():
	init = true

func stop():
	init = false

func _chase(delta):
	__move(delta,1)

func _dodge(delta):
	__move(delta,-1)

func _dash(delta):
	__move(delta,5)

func __move(delta, mod):
	velocity = Vector3.ZERO
	nav_agent.set_target_position(target.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED*mod
	look_at(Vector3(target.global_position.x,global_position.y,target.global_position.z), Vector3.UP)
	move_and_slide()

func _is_target_in_range():
	return global_position.distance_to(target.global_position) < attack_range


func _is_target_too_far():
	return global_position.distance_to(target.global_position) > too_far

func _cd_start(time):
	cd.wait_time = time
	cd.start()

func _cd_stop():
	cd.stop()

func _is_moving():
	return !(velocity.x == 0 && velocity.z == 0)

func hurt():
	if currentHealth > 0:
		damageSFX.play()
		currentHealth -= player.damage
	else:
		currentHealth = 0
		isDead = true
	healthChanged.emit()


func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("hurt"):
			body.hurt(20)
