extends State

@export var player: Player
@onready var dash_timer = $"../../DashTimer"
@onready var player_pivot: Node3D = $"../../Pivot"
@onready var dash_cooldown = $"../../DashCooldown"
@onready var animation = $"../../Pivot/AnimationPlayer"

var dash_speed: = 100.0
var dash_duration = 0.2
var dash_cooldown_duration = 2.0

func enter():
	animation.play("Aanim Run cycle") #substituir por animacao da dash quando estiver pronta
	player.set_collision_mask_value(2, false) #ignora colisao com inimigos durante a dash

func physics_update(delta: float):
	var direction = player.global_position
	if Input.is_action_just_pressed("dash"):  
		player.isDashing = true
		player.canDash = false 
		player.velocity = dash() 
		dash_timer.start(dash_duration)
		dash_cooldown.start(dash_cooldown_duration)

func dash() -> Vector3:
	var input_vector = player.get_input_direction()
	if not player.isMoving():
		var forward_vector = -player_pivot.global_transform.basis.z.normalized()
		input_vector.x = forward_vector.x
		input_vector.z = forward_vector.z
	return input_vector.normalized() * dash_speed 

func _on_dash_timer_timeout():
	player.set_collision_mask_value(2, true) #volta a colidir com inimigos quando encerra a dash
	player.isDashing = false
	Transitioned.emit(self, "run")

func _on_dash_cooldown_timeout():
	player.canDash = true
