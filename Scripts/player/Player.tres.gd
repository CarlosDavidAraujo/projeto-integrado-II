extends CharacterBody3D
class_name Player

signal HealthChanged

@export var speed: float  = 30
@export var max_health: float = 50
@export var damage: float = 5
@export var fall_acceleration = 75
@onready var animation_player = $Pivot/AnimationPlayer
@onready var hitbox = $Pivot/rig/Skeleton3D/WeaponAtachment/Hitbox
@onready var state_machine: StateMachine = $StateMachine

var current_health = max_health
var isAttacking = false
var isDashing = false
var isDead = false
var canDash = true

func _physics_process(delta):		
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y = velocity.y - fall_acceleration
	move_and_slide()

func _on_hitbox_body_entered(body):
	if body.is_in_group("mob"):
		if body.has_method("hurt"):
			body.hurt()

func get_input_direction() -> Vector3:
	var input_vector: Vector3 = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	return input_vector
	
func isMoving() ->bool:
	return get_input_direction() != Vector3.ZERO
	
func hurt(dmg: float):
	current_health -= dmg
	if current_health <= 0:
		isDead = true
	HealthChanged.emit()

func look_at_mouse_position():
	var target_mouse = get_viewport().get_mouse_position()
	var screen_size = get_viewport().get_visible_rect().size
	var center = screen_size / 2
	target_mouse -= center
	var target_position = global_position + Vector3(target_mouse.x, 0,target_mouse.y).normalized()
	$Pivot.look_at(target_position, Vector3.UP)
	
func look_at_move_direction():
	var direction = get_input_direction()
	$Pivot.look_at(global_position + direction.normalized(), Vector3.UP)
