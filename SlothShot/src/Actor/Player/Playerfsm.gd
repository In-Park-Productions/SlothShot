extends "res://src/Statemachine/mainFsm.gd"

func _init():
	states={
		1:"Holding_branch",
		2:"Launched",
		3:"Dragged",
		4:"Punch",
		5:"Dead"
	}
func state_logic(delta):
	pass
func transition(delta):
	pass
func animation(state):
	pass
func audio(state):
	pass

