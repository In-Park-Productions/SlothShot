extends Node
class_name finite_state_machine

onready var parent=get_parent()
var previous_state
var stack:Array


func _ready():
	self.stack=[]

func _physics_process(delta):
	var current_state=get_current_state()
	if current_state !=null:
		get_node(current_state).play_current_state(delta)
	var next_state=get_node(current_state).check_exit_condition(delta)
	if next_state!=null:
		previous_state=pop_state()
		push_state(next_state)
		get_node(next_state).check_previous_state_condition(previous_state)

	print(current_state)

func push_state(state):
	if get_current_state() !=state:
		stack.push_front(state)

func pop_state():
	return stack.pop_front()

func get_current_state():
	return stack[len(stack)-1] if len(stack)>0 else null
