extends State


func play_current_state(delta):
	stats[0].apply_gravity(delta)
	actor.move_and_slide(stats[0].current_velocity)

func check_exit_condition(delta):
	if actor.check_raycast_collision():
		return "Idle"
	if Input.is_action_pressed("E"):
		return "Land"

func check_previous_state_condition(previous_state):
	pass

func play_current_animation():
	pass
