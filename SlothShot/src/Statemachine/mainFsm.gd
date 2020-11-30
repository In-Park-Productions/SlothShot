extends Node

onready var parent=get_parent()

#states 
var states={}
var current_state 
var previous_state=null


func _process(delta):
	state_logic(delta)
	var state=transition(delta)
	if state!=null:
		print(state)
		animation(state)
		audio(state)
		current_state=state

func state_logic(delta):
	pass

func transition(delta):
	return null

func animation(state):
	pass

func audio(state):
	pass
