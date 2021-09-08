extends finite_state_machine




func _physics_process(delta):
	"""checks the current state and checks the animation of the player checks the current animations so that
	animation will play once when it is intened to do (loops will play looped) """
	var current_state=get_current_state()
	if current_state !=null:
		var anim=current_state if current_state!="Launched" else get_node(current_state).animation
		if parent.animation_player.current_animation!=current_state && get_node(current_state).current_play:
			parent.animation_player.play(anim)
		disable_raycast(current_state)

	._physics_process(delta)#this calls the physic process from the parent function 


func disable_raycast(current_state):
	var enabled=true if current_state in ["Idle","Fall","Land"] else false
	parent.enable_or_disable_raycast(enabled)
