extends State

@export var wolf: Wolf
@onready var animation_player = $"../../Pivot/AnimationPlayer"

func enter():
	wolf.velocity = Vector3.ZERO
	animation_player.play("idle")
