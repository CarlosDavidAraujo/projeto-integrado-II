extends CharacterBody3D
class_name Player
signal HealthChanged

@export var SPEED: float = 30
@export var max_health: float = 1000
@export var damage: float = 200
@export var fall_acceleration: float
@onready var animation_player = $Pivot/AnimationPlayer
@onready var hitbox = $Pivot/rig/Skeleton3D/WeaponAtachment/Hitbox
@onready var state_machine: _StateMachine = $StateMachine
@onready var damege = $damege
@onready var dash_cd = $StateMachine/DashCD
@onready var dash_duration = $StateMachine/DashDuration
@onready var combo_window = $StateMachine/ComboWindow

var current_health = max_health
var can_dash = true
var is_dead = false
var is_attacking = false

func _physics_process(delta):
		# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y = velocity.y - fall_acceleration

func _run(delta):
	_look_at_move_direction()
	__move(delta, 1)

func _dash():
	velocity = _get_dash_direction() * SPEED * 5
	_look_at_move_direction()
	move_and_slide()
	
func _on_dash_cd_timeout():
	can_dash = true
	
func _attack():
	is_attacking = true
	_look_at_mouse_direction()

func is_moving():
	return velocity != Vector3.ZERO
	
func is_dashing():
	return !dash_duration.is_stopped()

func _on_hitbox_body_entered(body):
	if body.is_in_group("mob"):
		if body.has_method("hurt"):
			body.hurt()
			
func _get_input_direction() -> Vector3:
	var input_vector: Vector3 = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	return input_vector
	
func _get_dash_direction() -> Vector3:
	var input_vector = _get_input_direction()
	if not _is_move_input_pressed():
		var forward_vector = -$Pivot.global_transform.basis.z.normalized()
		input_vector.x = forward_vector.x
		input_vector.z = forward_vector.z
	return input_vector.normalized()
		
func hurt(dmg: float):
	current_health -= dmg
	damege.play()
	if current_health <= 0:
		is_dead = true
		get_tree().change_scene_to_file("res://Scenes/menu_inicial.tscn")
	HealthChanged.emit()

func _look_at_mouse_direction():
	var target_mouse = get_viewport().get_mouse_position()
	var screen_size = get_viewport().get_visible_rect().size
	var center = screen_size / 2
	target_mouse -= center
	var target_position = global_position + Vector3(target_mouse.x, 0,target_mouse.y).normalized()
	$Pivot.look_at(target_position, Vector3.UP)
	
func _look_at_move_direction():
	var direction = _get_input_direction()
	$Pivot.look_at(global_position + direction.normalized(), Vector3.UP)

func __move(delta, mod):
	velocity = _get_input_direction() * SPEED * mod
	move_and_slide()
	
func _is_move_input_pressed():
	return _get_input_direction() != Vector3.ZERO

func _input(event):
	if event.is_action_pressed("light_attack"):
		combo_window.start()
		
