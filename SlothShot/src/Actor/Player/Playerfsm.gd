extends "res://src/Statemachine/mainFsm.gd"

var facing
var direction_faced:float
var elasped_angle:float=0.0

#state stuff
class drag:
	var dragging:bool=false
	var current_mouse_length=0.0 setget set_current_mouse_length
	var previous_mouse_length=0.0
	enum {short,long}
	var mode=short
	var anim="Short"
	func set_current_mouse_length(value:Vector2)->void:
		current_mouse_length=value.length()
		current_mouse_length=clamp(current_mouse_length,0.0,200.0)




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



onready var drag_state=drag.new()


func _ready():
	drag_state.set_current_mouse_length(Vector2(20,20))
	#facing=parent.calculatefacing(direction_faced)
	pass

func state_logic(delta):
	if drag_state.dragging:
		on_mousebutton_pressed()
	if !drag_state.dragging:
		on_mousebutton_released()
	check_dragging_released()
func transition(delta):
	return null

func _enter_state(_old_state,_new_state):
	._enter_state(_old_state,_new_state)
	match _new_state:
		"_":
			pass


func _exit_state(_new_state,_old_state):
	match _old_state:
		"_":
			pass


#this is for dragstate 
func _on_Drag_Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index==BUTTON_LEFT:
		print("Hi")
		drag_state.dragging=true


func check_dragging_released():
	if Input.is_action_just_released("Click"):
		drag_state.dragging=false

func on_mousebutton_pressed():
	parent.previous_mouse_position=Vector2()
	parent.drag_vector=parent.global_position-parent.get_global_mouse_position()
	parent.drag_vector=parent.drag_vector.clamped(100)
	rotate_sloth()
	animate_according_to_mouse_position(parent.global_position-parent.get_global_mouse_position())

func on_mousebutton_released():
	parent.previous_mouse_position=parent.get_local_mouse_position()
	parent.previous_mouse_position=parent.previous_mouse_position.clamped(100)

func rotate_sloth():
	var rotation=(parent.global_position-parent.get_global_mouse_position()).angle()
	parent.rotation=lerp_angle(parent.rotation,rotation,0.1)
	parent.rotation=clamp(parent.rotation,-1.20,1.20)

func animate_according_to_mouse_position(mouse_position:Vector2):
	drag_state.set_current_mouse_length(mouse_position)
	if drag_state.current_mouse_length!=drag_state.previous_mouse_length:
		drag_state.previous_mouse_length=drag_state.current_mouse_length
		animate_sloth(drag_state.current_mouse_length,physics.calculate_facing(mouse_position))
	elif drag_state.current_mouse_length==drag_state.previous_mouse_length:
		parent.animation_player.stop(false)

func animate_sloth(current_length:float,facing_and_mouse:Array):
	var signum_mouse_position=facing_and_mouse[0]
	var facing_front=facing_and_mouse[1]
	print(facing_front)
	var mouse_position=facing_and_mouse[2]
	var value = current_length*signum_mouse_position*0.5
	var desired_value=value if value>0 else 0
	print(desired_value)
	if desired_value>=20 && desired_value <50:
		drag_state.anim="Short"
	elif desired_value>50:
		drag_state.anim="Long"
	else:
		parent.animation_player.stop()
	parent.animation_player.play("Dragged_"+drag_state.anim,-1,1.0,false) 

func Todo():
	#TODO:Complete player animation
	pass




func _on_AnimationPlayer_animation_finished(anim_name):
	pass
