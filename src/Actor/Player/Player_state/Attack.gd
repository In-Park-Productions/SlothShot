extends State
var attack_finished=false

func play_current_state(delta):
	pass

func check_exit_condition(delta):
	if attack_finished:
		attack_finished=false
		return "Fall"


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name in ["Attack"]:
		attack_finished=true
