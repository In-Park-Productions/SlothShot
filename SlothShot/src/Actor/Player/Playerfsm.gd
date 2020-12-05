extends "res://src/Statemachine/mainFsm.gd"

var facing
var direction_faced:float
var elasped_angle:float=0.0

var dragging:bool=false


func _init():
	states={
		1:"Holding_branch",
		"Launched":{
			1:"Assend",
			2:"decend"
		},
		3:"Dragged",
		4:"Fight",
		5:"Dead"
	}

func _ready():
	direction_faced=-(parent.get_local_mouse_position().x)
	#facing=parent.calculatefacing(direction_faced)
	pass

func state_logic(delta):
	if dragging:
		on_mousebutton_pressed()
	if !dragging:
		on_mousebutton_released()
	check_dragging_released()
func transition(delta):
	pass

func _enter_state(_old_state,_new_state):
	._enter_state(_old_state,_new_state)
	match _new_state:
		"_":
			pass


func _exit_state(_new_state,_old_state):
	pass



func _on_Drag_Area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click"):
		print("Hi")
		dragging=true

func check_dragging_released():
	if Input.is_action_just_released("Click"):
		dragging=false
func on_mousebutton_pressed():
	parent.previous_mouse_position=Vector2()
	parent.drag_vector=parent.global_position-parent.get_global_mouse_position()
	parent.drag_vector=parent.drag_vector.clamped(100)
	rotate_sloth()
func on_mousebutton_released():
	parent.previous_mouse_position=parent.get_local_mouse_position()
	parent.previous_mouse_position=parent.previous_mouse_position.clamped(80)

func rotate_sloth():
	var rotation=(parent.global_position-parent.get_global_mouse_position()).angle()
	parent.rotation=lerp_angle(parent.rotation,rotation,0.4)
