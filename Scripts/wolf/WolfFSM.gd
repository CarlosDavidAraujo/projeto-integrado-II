extends "res://Scripts/_StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("dodge")
	add_state("hit")
	add_state("dead")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	if [states.run, states.idle].has(state):
		parent._chase(delta)

func _get_transition(delta):
	if parent.currentHealth <= 0:
		return states.dead
	match state:
		states.idle:
			if(parent._is_target_in_range()):
				return states.hit
			if(parent._is_moving()):
				return states.run
		states.run:
			if(parent._is_target_in_range()):
				return states.hit
			if(!parent._is_moving()):
				return states.idle
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.wolf_anim.play("idle")
		states.run:
			parent.wolf_anim.play("run")
		states.hit:
			parent.wolf_anim.play("dash")
		states.dodge:
			parent.wolf_anim.play_backwards("pulo")
		states.dead:
			parent.wolf_anim.play("idle")			

func _exit_state(old_state, new_state):
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dash":
		set_state(states.idle)
