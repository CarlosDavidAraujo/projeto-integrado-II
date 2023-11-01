extends State

@export var player: Player
@onready var dash_timer = $"../../DashTimer"
@onready var player_pivot: Node3D = $"../../Pivot"

var dash_speed: = 100.0
var dash_duration = 0.2
var dash_cooldown_duration = 2.0

func physics_update(delta: float):
	var direction = player.global_position
	if Input.is_action_just_pressed("dash"):  
		player.isDashing = true
		player.canDash = false 
		player.velocity = dash() 
		player.animation_player.play("Aanim Run cycle")
		dash_timer.start(dash_duration)
		player.dash_cooldown.start(dash_cooldown_duration)

func dash() -> Vector3:
	var input_vector: Vector3 = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	if input_vector == Vector3.ZERO:
		var forward_vector = -player_pivot.global_transform.basis.z.normalized()
		input_vector.x = forward_vector.x
		input_vector.z = forward_vector.z
	return input_vector.normalized() * dash_speed 

func _on_dash_timer_timeout():
	player.isDashing = false
	Transitioned.emit(self, "run")

