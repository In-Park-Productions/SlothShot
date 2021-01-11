extends Node

onready var parent=get_parent()

#states 
var states={}
var current_state 
var previous_state=null




func _physics_process(delta):
	state_logic(delta)
	var state=transition(delta)
	if state!=null:
		previous_state=current_state
		current_state=state
		print(state)
		_enter_state(previous_state,current_state)
		_exit_state(current_state,previous_state)

func state_logic(delta):
	pass

func transition(delta):
	return null

func _enter_state(_old_state,_new_state):
	pass

func _exit_state(_new_state,_old_state):
	pass
#this is the code physic process behind it
