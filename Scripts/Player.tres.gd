extends CharacterBody3D
class_name Player

@export var speed = 30
@onready var animation_player = $Pivot/AnimationPlayer
@onready var hitbox = $Pivot/rig/Skeleton3D/WeaponAtachment/Hitbox
@onready var state_machine: StateMachine = $StateMachine
@onready var dash_cooldown: Timer = $DashCooldown

var isAttacking = false
var isDashing = false
var canDash = true
var damage: float = 5.0

func _physics_process(delta):		
	move_and_slide()

func _on_hitbox_body_entered(body):
	if body.is_in_group("mob"):
		if body.has_method("hurt"):
			body.hurt()

func _on_dash_cooldown_timeout():
	canDash = true # Replace with function body.
