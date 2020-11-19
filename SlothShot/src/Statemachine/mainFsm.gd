extends Node
class_name statemachinefsm
onready var parent=get_parent()

signal state_changed(old_state,new_state)

var state=null
var previous_state=null
var states={}


func _physics_process(delta):
	var _state=get_node(state) if state else null
	if _state==null ||parent==null:
		return
	_state.transition(delta)
	_state.state_logic(delta)

func register_state(state_name):
	state[state_name]=state_name

func set_up_inital_stage(inital_stage):
	for _states in states:
		get_node(_states).parent=parent
	
	on_set_stage(inital_stage)
	
func on_set_stage(new_stage):
	emit_signal("state_changed",state,new_stage)
	previous_state=state
	state=new_stage
