extends "res://Scripts/_StateMachine.gd"

@onready var debug = $SubViewport/Label

func _ready():
	add_state("idle")
	add_state("run")
	add_state("dodge")
	add_state("hit")
	add_state("dash")
	add_state("dead")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	debug.text = "State: {0}".format(state)
	
	if [states.run].has(state):
		parent._chase(delta)
	if [states.dash].has(state):
		parent._dash(delta)
	if [states.dodge].has(state):
		parent._dodge(delta)
		
	if parent._is_target_too_far():
		print("Too far")
		if parent.cd.is_stopped():
			parent._cd_start(5)
	else:
		print("Close enough")
		parent._cd_stop()

func _get_transition(delta):
	if !parent.init:
		return null
	if parent.isDead:
		return states.dead
	match state:
		states.idle:
			if(parent._is_target_in_range()):
				return states.hit
			else:
				return states.run
			if(parent._is_moving()):
				return states.run
		states.run:
			if(parent._is_target_in_range()):
				return states.hit
			elif(!parent._is_moving()):
				return states.idle
	return null

func _enter_state(new_state, old_state):
	parent.wolf_anim.play("RESET")
	match new_state:
		states.idle:
			parent.wolf_anim.play("idle")
		states.run:
			parent.wolf_anim.play("run")
		states.hit:
			parent.wolf_anim.play("dash")
		states.dash:
			parent.wolf_anim.play("dash")
		states.dodge:
			parent.wolf_anim.play("pulo")
		states.dead:
			parent.wolf_anim.play("idle")

func _exit_state(old_state, new_state):
	pass

func _on_animation_player_animation_finished(anim_name):
	if ["dash"].has(anim_name):
		set_state(states.dodge)
	if ["pulo"].has(anim_name):
		set_state(states.idle)

func _on_cd_timeout():
	print("ATTACK")
	if parent._is_target_too_far():
		print("NOW!")
		set_state("dash")
