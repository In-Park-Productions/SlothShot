extends Area2D

export var rotating_factor=1


func _on_Slopearea_body_entered(body):
	print("hi")
	var playerfsm=body.get_node("PlayerFSM")
	playerfsm.dead_state.dead_on_slope=true
	playerfsm.dead_state.rotate_factor=rotating_factor
	print(playerfsm.dead_state.dead_on_slope)
