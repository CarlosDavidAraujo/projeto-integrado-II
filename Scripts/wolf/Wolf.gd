extends CharacterBody3D
class_name Wolf
signal healthChanged

@export var player: Player
@export var maxHealth = 75
@export var damage = 7.5
@export var fall_acceleration = 75
@onready var currentHealth: int = maxHealth
@onready var wolf_anim = $Pivot/AnimationPlayer
@onready var attack_collision = $AttackHitBox/CollisionShape3D
@onready var state_machine: StateMachine = $StateMachine
@onready var damege = $damege
@onready var evasion_cd : Timer = $EvasionCD
@onready var attack_cd : Timer = $AttackCD
@onready var animation_player: AnimationPlayer = $Pivot/AnimationPlayer
@onready var dash_window: Timer = $DashWindow

var speed = 20
var isDead = false
var is_in_melee_range = false
var can_evade = true
var can_attack = true

func _ready():
	attack_collision.disabled = true

func _physics_process(delta):
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y = velocity.y - fall_acceleration
	move_and_slide()

func hurt():
	currentHealth -= player.damage
	damege.play()
	if currentHealth <= 0:
		isDead = true
		state_machine.set_state("dead")
	healthChanged.emit()
	
func _on_attack_range_body_entered(body):
	if body.is_in_group("player"):
		is_in_melee_range = true
	
func _on_attack_range_body_exited(body):
	if body.is_in_group("player"):
		is_in_melee_range = false

func _on_evasion_cd_timeout():
	can_evade = true
	
func _on_attack_cd_timeout():
	can_attack = true
	
func _on_dash_window_timeout():
	if not isDead:
		state_machine.set_state("dash")
		






