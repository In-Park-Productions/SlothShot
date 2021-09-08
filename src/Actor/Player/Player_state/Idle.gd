extends State


onready var Dragg_state=get_parent().get_node("Dragged")

func play_current_state(delta):
	actor.Player_kinematics.current_velocity=Vector2(0,0)

func check_exit_condition(delta):
	if  ! actor.check_raycast_collision():
		return "Fall" 
	if Dragg_state.is_being_clicked:
		return "Dragged"

		
func check_previous_state_condition(previous_state):
	pass

func play_current_animation():
	pass
