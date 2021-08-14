extends State

func play_current_state(delta):
	stats[0].apply_gravity(delta)
	actor.move_and_slide(stats[0].current_velocity)


func check_exit_condition(delta):
	if Input.is_action_just_released("Land"):
		return "Fall"

