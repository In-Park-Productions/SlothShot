extends State


var animation="Launched"

func play_current_state(delta):
	print(stats[0].trajectory)
	if stats[0].trajectory==stats[0].mode.assend:
		stats[0].apply_velocity(delta)
	actor.move_and_slide(stats[0].current_velocity)

func check_exit_condition(delta):
	if stats[0].trajectory==stats[0].mode.decend:
		stats[0].trajectory=stats[0].mode.assend
		return "Fall"
	if Input.is_action_pressed("E"):
		return "Attack"
func check_previous_state_condition(previous_state):
	pass


func play_current_animation():
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="Launched":
		animation="Launched_Mid"

