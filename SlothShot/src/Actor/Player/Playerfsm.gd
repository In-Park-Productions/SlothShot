extends "res://src/Statemachine/mainFsm.gd"


#state stuff

class drag:
	#tween under constant so it will help us to understand
	const tween_sine=Tween.TRANS_SINE
	const EASE_IN_OUT=Tween.EASE_IN_OUT
	#makes 
	var dragging:bool=false
	var anim:String="Short"
	var current_mouse_position:Vector2=Vector2() 
	var last_mouse_position:Vector2=Vector2()
	var diffrence:float=0.0
	enum {short_check,long_check}
	var check
	var backward
class launched:
	var fire_velocity:Vector2=Vector2()
	var mouse_position:Vector2
	var time_of_flight:float
	var final_velocity:Vector2=Vector2()
	enum{launched,moving,none}
	var path=none
func _init():
	states={
		1:"Idle",
		2:"Launched",
		3:"Dragged",
		4:"Fight",
		5:"Dead"
	}



onready var drag_state=drag.new()
onready var launch_state=launched.new()

func _ready()->void:
	current_state=states[1]
	randomize()
	pass

func state_logic(delta)->void:
	if current_state in ["Dragged"]:
		on_mousebutton_pressed()
	if current_state in ["Launched"]:
			on_mousebutton_released()
			if launch_state.path==launch_state.launched:
				calculate_the_trajectory()
	check_dragging_released()

func transition(delta):
	match current_state:
		"Idle":
			if drag_state.dragging:
				return states[3]
		"Dragged":
			if !drag_state.dragging:
				return states[2]
		"Assend":
				return null
			
	return null

func _enter_state(_old_state,_new_state):
	match _new_state:
		'_':
			pass


func _exit_state(_new_state,_old_state):
	match _old_state:
		"_":
			pass


#this is for dragstate 
func _on_Drag_Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index==BUTTON_LEFT:
		#it triggers the drag_state
		drag_state.dragging=true


func check_dragging_released()->void:
	if Input.is_action_just_released("Click"):
		#it makes the 
		drag_state.dragging=false

func on_mousebutton_pressed()->void:
	var diffrence_mouse_position:Vector2=parent.global_position-parent.get_global_mouse_position()
	parent.drag_vector=parent.get_global_mouse_position()-parent.global_position
	parent.drag_vector=parent.drag_vector.clamped(80)
	rotate_sloth()
	Animatate_sloth_acording_to_mouse_position(diffrence_mouse_position)

func on_mousebutton_released()->void:
	if launch_state.path==launch_state.none:
		launch_state.mouse_position =parent.global_position-parent.get_global_mouse_position()
		launch_state.path=launch_state.launched
	

func rotate_sloth()->void:
	var temp=parent.global_position-parent.get_global_mouse_position()
	var rotation=(temp).angle() if temp.x>0 else parent.rotation
	var tween = Tween.new()
	parent.add_child(tween)
	tween.interpolate_property(parent,"rotation",parent.rotation,rotation,0.1,drag_state.tween_sine,drag_state.EASE_IN_OUT)
	tween.start()

func Todo():
	#TODO:Complete player physics
	pass

func Animatate_sloth_acording_to_mouse_position(mouse_position:Vector2)->void:
	calculate_facing(parent.get_local_mouse_position())
	if drag_state.diffrence==1:
		drag_state.backward=false
	elif drag_state.diffrence==-1:
		drag_state.backward=true
	else:
		drag_state.backward=null

	if drag_state.backward==false:
		parent.animation_player.play("Dragged_"+drag_state.anim)
	elif drag_state.backward==true:
		parent.animation_player.play_backwards("Dragged_"+drag_state.anim)
	else:
		parent.animation_player.stop(false)


	match drag_state.check:
		drag_state.short_check:
			if drag_state.diffrence==1:
				drag_state.anim="Short"
				drag_state.check="_"
			else:
				parent.animation_player.stop(false)
		drag_state.long_check:
			if drag_state.diffrence==-1:
				drag_state.anim="Short"
				drag_state.check="_"
			else:
				parent.animation_player.stop(false)
		"_":
			pass


func calculate_facing(mouse_position:Vector2)->void:
	drag_state.current_mouse_position=mouse_position
	var diffrence=int(drag_state.current_mouse_position.x-drag_state.last_mouse_position.x)
	yield(get_tree(),"physics_frame")
	drag_state.last_mouse_position=drag_state.current_mouse_position
	drag_state.diffrence=sign(-diffrence)

#calls in animation_player(Drag_state)
func on_short_finished()->void:
	if drag_state.diffrence==-1:
		drag_state.anim="Short"
	else:
		drag_state.anim="Long"

func on_long_finished()->void:
	if drag_state.anim=="Long"&&drag_state.diffrence==1:
		drag_state.check=drag_state.long_check

func on_long_start()->void:
	if drag_state.diffrence==-1:
		drag_state.anim="Short"
	elif drag_state.diffrence==1:
		drag_state.anim="Long"

func on_short_start()->void:
	if drag_state.anim=="Short"&&(drag_state.diffrence==-1 || drag_state.diffrence==0):
		drag_state.check=drag_state.short_check
#Launched state
func calculate_the_trajectory():
	if launch_state.path==launch_state.launched:
		parent. apply_velocity(launch_state.mouse_position,parent.LaunchVelocity)
