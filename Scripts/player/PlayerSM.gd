extends "res://Scripts/_StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("light_attack")
	add_state("heavy_attack")
	add_state("dash")
	add_state("dead")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	if !parent.is_dead:
		if [states.run].has(state):
			parent._run(delta)
		if [states.dash].has(state):
			parent._dash()
		if [states.light_attack].has(state):
			parent._attack()
		if [states.heavy_attack].has(state):
			parent._attack()
			
func _get_transition(delta):
	if parent.is_dead:
		return states.dead
	if Input.is_action_just_pressed("dash") && parent.can_dash:
		return states.dash
	if Input.is_action_just_pressed("light_attack") && !parent.is_attacking && !parent.is_dashing():
		return states.light_attack
	if Input.is_action_just_pressed("heavy_attack") && !parent.is_attacking && !parent.is_dashing():
		return states.heavy_attack
	match state:
		states.idle:
			if parent._is_move_input_pressed():
				return states.run
		states.run:
			if not parent._is_move_input_pressed():
				return states.idle
		states.light_attack:
			if parent.combo_window.is_stopped():
				return states.run
	return null

func _enter_state(new_state, old_state):
	parent.animation_player.play("RESET")
	match new_state:
		states.idle:
			parent.animation_player.play("Aanim Idle cycle 02")
		states.run:
			parent.animation_player.play("Aanim Run cycle")
		states.dash:
			parent.set_collision_mask_value(2, false)
			parent.can_dash = false
			parent.dash_duration.start()
			parent.animation_player.play("Aanim Run cycle")
		states.dead:
			parent.animation_player.play("Aanim Idle cycle 02")
		states.light_attack:
			parent.hitbox.monitoring = true
			parent.animation_player.play("Aanim attack 01")
		states.heavy_attack:
			parent.hitbox.monitoring = true
			parent.animation_player.play("Aanim heavy attack")
			
func _exit_state(old_state, new_state):
	match old_state:
		states.dash:
			parent.set_collision_mask_value(2, true)
		states.light_attack:
			parent.is_attacking = false
			parent.hitbox.monitoring = false
		states.heavy_attack:
			parent.is_attacking = false
			parent.hitbox.monitoring = false	

func _on_dash_duration_timeout():
	parent.dash_cd.start()
	set_state(states.run)
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Aanim attack 01" && !parent.combo_window.is_stopped():
		parent.animation_player.play("Aanim attack 02")
	if anim_name == "Aanim attack 02" && !parent.combo_window.is_stopped():
		parent.animation_player.play("Aanim attack 01")
	if anim_name == "Aanim heavy attack":
		set_state(states.run)
