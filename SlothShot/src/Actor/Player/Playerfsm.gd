extends "res://src/Statemachine/mainFsm.gd"


# short note before continuing i used classes to represent the state so it wont lead to spagetti code and the classes 
# are declared under ready function like  onready var a=a_class.new()
# dragclass
class drag:
	# tween under constant so it will help us to understand
	const tween_sine=Tween.TRANS_SINE
	const EASE_IN_OUT=Tween.EASE_IN_OUT
	# makes return dragging if true it does to drag state or if its false it goes to idle or launch
	var dragging:bool=false
	# intial animation position
	var anim:String="Short"
	# current mouse position
	var current_mouse_position:Vector2=Vector2() 
	# last mouse position
	var last_mouse_position:Vector2=Vector2()
	# diffrence of last mouse position and current one
	var diffrence:float=0.0
	# check are for checking the anmation after the end of animation
	enum {short_check,long_check}
	var check
	# determines the animation to play backwards if true it will be back or else it will go front
	var backward
# this class uses launch_state variables
class launched:
	#keeps the track of mouseposition and it stores it under this variable 
	var mouse_position:Vector2=Vector2()
	enum{launched,not_launched}
	var mode=not_launched
func _init():
	# you declare state under the main fsm 
	states={
		1:"Idle",
		2:"Launched",
		3:"Dragged",
		4:"Fight",
		5:"Dead"
	}


#getiing classes
onready var drag_state=drag.new()
onready var launch_state=launched.new()

func _ready()->void:
	#intial state starts with idle
	current_state=states[1]
	pass

func state_logic(delta)->void:
	# here all logic goes on like do action in specific state i used array coz as state increases we cant add 
	# or condition 
	if current_state in ["Dragged"]:
		on_mousebutton_pressed()
	if current_state in ["Launched"]:
			on_mousebutton_released()
			if launch_state.mode==launch_state.launched:
				calculate_the_trajectory()
	#check for dragging it tiggers transition
	check_dragging_released()

func transition(delta):
	#transition from one state to other take place with its unique ability 
	match current_state:
		"Idle":
			#if its dragging it transit to drag state
			if drag_state.dragging:
				return states[3]
		"Dragged":
			# if its released it goes to launch to other state launch
			if !drag_state.dragging:
				return states[2]
		"Launched":
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
		#if its released it makes dragging to false so dragging actions wont happen
		drag_state.dragging=false

# proceeds to state if its pressed
func on_mousebutton_pressed()->void:
	var diffrence_mouse_position:Vector2=parent.global_position-parent.get_global_mouse_position()
	#rotates the sloth
	rotate_sloth()
	#animates the sloth according to the mouse position
	Animatate_sloth_acording_to_mouse_position(diffrence_mouse_position)
# it falls under multiple states
func on_mousebutton_released()->void:
	# if the sloth is not launched it will calculate the mouse position and send that parameter to
	# cakculate trajectory function
	if launch_state.mode==launch_state.not_launched:
		launch_state.mouse_position =parent.global_position-parent.get_global_mouse_position()
		launch_state.mode=launch_state.launched

# roates the sloth according to the mouse positons and added tweening to get smooth turn than lerping 
func rotate_sloth()->void:
	var temp=parent.global_position-parent.get_global_mouse_position()
	var rotation=(temp).angle() if temp.x>0 else parent.rotation
	# I created the tween coz if we add it the trees will be messy and hard to program
	var tween = Tween.new()
	parent.add_child(tween)
	tween.interpolate_property(parent,"rotation",parent.rotation,rotation,0.1,drag_state.tween_sine,drag_state.EASE_IN_OUT)
	tween.start()

func Todo():
	#TODO:Launch animation
	pass
#animates the sloth
func Animatate_sloth_acording_to_mouse_position(mouse_position:Vector2)->void:
	# calculates the direction of sloth if the mouse moves forward it will gives true if back false else it will 
	# give null
	calculate_diffrence(mouse_position)
	# returns dragstate according to the diffrence
	if drag_state.diffrence==1:
		drag_state.backward=false
	elif drag_state.diffrence==-1:
		drag_state.backward=true
	else:
		drag_state.backward=null
#if its backwards it will play back or it will play forward else it will stop the animation
	if drag_state.backward==false:
		parent.animation_player.play("Dragged_"+drag_state.anim)
	elif drag_state.backward==true:
		parent.animation_player.play_backwards("Dragged_"+drag_state.anim)
	else:
		parent.animation_player.stop(false)

# check for dragging and transitions to other animation
	match drag_state.check:
		drag_state.short_check:
			if drag_state.diffrence==1:
				drag_state.anim="Short"
				drag_state.check="_"
			else:
				parent.animation_player.stop(false)
		drag_state.long_check:
			if drag_state.diffrence==-1&&drag_state.anim=="Long":
				drag_state.anim="Short"
				drag_state.check="_"
			else:
				parent.animation_player.stop(false)
		"_":
			pass


#calculates the diffrence and sets the diffrence sign of mouse position 
func calculate_diffrence(mouse_position:Vector2)->void:
	drag_state.current_mouse_position=mouse_position
	var diffrence=int(drag_state.current_mouse_position.x-drag_state.last_mouse_position.x)
	yield(get_tree(),"physics_frame")
	drag_state.last_mouse_position=drag_state.current_mouse_position
	drag_state.diffrence=sign(diffrence)


#calls in animation_player(Drag_state)
# short note it is called inside the animation player
# it trrigers after the animation check for the  animation and sets the animation
func on_short_finished()->void:
	if drag_state.diffrence==-1:
		drag_state.anim="Short"
	elif drag_state.diffrence==1:
		drag_state.anim="Long"

# it does things after long its being checked with match condition
func on_long_finished()->void:
	if drag_state.anim=="Long"&&drag_state.diffrence==1:
		drag_state.check=drag_state.long_check

# it does stuffs when it starts check for diffrence and sets the animation
func on_long_start()->void:
	if drag_state.diffrence==-1:
		drag_state.anim="Short"
	elif drag_state.diffrence==1:
		drag_state.anim="Long"

# same as long start 
func on_short_start()->void:
	if drag_state.anim=="Short"&&(drag_state.diffrence==-1 || drag_state.diffrence==0):
		drag_state.check=drag_state.short_check




#it works under Launched state 
# calculates the trajectory after itss fires this function is called in player
func calculate_the_trajectory()->void:
	if launch_state.mode==launch_state.launched:
		parent. apply_velocity(launch_state.mouse_position,parent.LaunchVelocity)
