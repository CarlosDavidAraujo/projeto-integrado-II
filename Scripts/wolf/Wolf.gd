extends CharacterBody3D
class_name Wolf
signal healthChanged

const SPEED = 50

var target = null
@export var targetPath : NodePath
@export var attack_range: float

func _ready():
	target = get_node(targetPath)
	healthChanged.emit()

@export var maxHealth = 30
@onready var currentHealth: int = maxHealth
@onready var wolf_anim = $Pivot/AnimationPlayer
@onready var nav_agent = $NavigationAgent3D

var isDead = false

func _chase(delta):
	velocity = Vector3.ZERO
	nav_agent.set_target_position(target.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	look_at(Vector3(target.global_position.x,global_position.y,target.global_position.z), Vector3.UP)
	move_and_slide()

func _is_target_in_range():
	return global_position.distance_to(target.global_position) < attack_range

func _is_moving():
	return !(velocity.x == 0 && velocity.z == 0)

func hurt():
	currentHealth -= 3
	if currentHealth <= 0:
		isDead = true
	healthChanged.emit()


