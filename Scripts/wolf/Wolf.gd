extends CharacterBody3D
class_name Wolf
signal healthChanged

@export var player: Player
@export var maxHealth = 100
@export var damage = 10
@export var fall_acceleration = 75
@onready var currentHealth: int = maxHealth
@onready var wolf_anim = $espirito_02/AnimationPlayer
@onready var attack_collision = $AttackHitBox/CollisionShape3D
@onready var state_machine: StateMachine = $StateMachine

var speed = 20
var isDead = false
var is_in_melee_range = false

func _ready():
	attack_collision.disabled = true

func _physics_process(delta):
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y = velocity.y - fall_acceleration 
	move_and_slide()
	
func _on_attack_range_body_entered(body):
	if body.is_in_group("player"):
		is_in_melee_range = true

func _on_attack_range_body_exited(body):
	if body.is_in_group("player"):
		is_in_melee_range = false

func hurt():
	currentHealth -= player.damage
	if currentHealth <= 0:
		isDead = true
		state_machine.set_state("dead")
	healthChanged.emit()
