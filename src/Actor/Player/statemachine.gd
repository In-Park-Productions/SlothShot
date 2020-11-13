extends Node

onready var player = get_parent()

var current_state={
	1:"Idle",
	2:"swing",
	3:"fall",
	4:"dead"
}
var previous_state=null
func _ready():
	previous_state=current_state[1]
func _physics_process(delta:float):
	states_logic(delta)
	if previous_state!=null:
		var state = transition(delta)
		if state !=null:
			animation(state)
	pass
func states_logic(delta:float):
	pass
func transition(delta:float):
	return null
func animation(state):
	pass
