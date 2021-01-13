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
	# difference of last mouse position and current one
	var difference:float=0.0
	# check are for checking the anmation after the end of animation
	enum {short_check,long_check}
	var check
	# determines the animation to play backwards if true it will be back or else it will go front
	var backward
	#tracks the length
	var length

# this class uses launch_state variables
class launched:
	#keeps the track of mouseposition and it stores it under this variable 
	var mouse_position:Vector2=Vector2()
	var local_mouse_position:Vector2=Vector2()
	enum{launched,not_launched}
	var mode=not_launched
	var stop:bool=false
	var launch_anim="Long"
class fall:
	var collided_with_ground=null



class landing:
	var can_land=false
	var is_in_tree=true

class Idle:
	var is_colliding=false

class dead:
	var is_dead=false 
	var bunp_velocity:float=-100
	var movement=true
func _init():
	# you declare state under the main fsm 
	states={
		1:"Idle",
		2:"Launched",
		3:"Dragged",
		4:"Fall",
		5:"Land",
		6:"Dead"
	}


#getiing classes
onready var drag_state=drag.new()
onready var launch_state=launched.new()
onready var land_state=landing.new()
onready var fall_state=fall.new()
onready var idle_state=Idle.new()
onready var dead_state=dead.new()

func _ready()->void:
	#intial state starts with idle
	current_state=states[1]


func state_logic(delta)->void:
	# here all logic goes on like do action in specific state i used array coz as state increases we cant add 
	# or condition 
	
	if current_state in ["Launched","Fall","Land"]:
		fall_state.collided_with_ground=parent.apply_movements()
		if fall_state.collided_with_ground:
			dead_state.is_dead=true
	if current_state in ["Idle"]:
		parent.mode=parent.assend
		launch_state.mode=launch_state.not_launched
		land_state.can_land=false
		idle_state.is_colliding=parent.check_for_collision()
	if current_state in ["Dragged"]:
		on_mousebutton_pressed()
	if current_state in ["Launched"]:
		on_mousebutton_released()
		calculate_the_trajectory()
	
	if current_state in ["Land"]:
		var collision=parent.check_for_collision()
		if collision:
			on_landing()

	if current_state in ["Fall","Land","Dead"]:
		parent.LaunchVelocity.y+=parent.Gravity*get_physics_process_delta_time()
		if current_state in ["Fall"]:
			land_state.is_in_tree=false
	if current_state in ["Dead"]:
		#add a small bump
		on_dead()
	#check for dragging it tiggers transition
	check_dragging_released()
	trriger_condition()



func trriger_condition():
	# raycast may be appering to be visible when you see in editor but in game it disables and it enables
	# at Land,Idle,Dragged
	var ray_disabled=false if current_state in ["Land","Idle","Dragged"] else true
	parent.enable_raycast(ray_disabled)



func transition(delta):
	# transition from one state to other take place with its unique ability 
	match current_state:
		"Idle":
			#if mouse is dragging object transition object state to "Dragged"
			if drag_state.dragging:
				return states[3] # 3 = Dragged
			if ! idle_state.is_colliding:
				return states[4]
			if dead_state.is_dead:
				return states[6]
		"Dragged":
			# if object is released from Dragged state
			if !drag_state.dragging:
				if  drag_state.length>75:
					return states[2]
				else:
					return states[1]
		"Launched":
			if parent.mode==parent.decend:
				return states[4]
			if dead_state.is_dead:
				return states[6]
		"Fall":
			if land_state.can_land:
				return states[5]
			if dead_state.is_dead:
				return states[6]
		"Land":
			if parent.mode==parent.Idle:
				return states[1]
			if dead_state.is_dead:
				return states[6]
	return null


func _enter_state(_old_state,_new_state):
	var anim="Idle"
	match _new_state:
		"Idle":
			anim="IdleVertical"
		"Launched":
			var mode = "Start"  if parent.mode==parent.assend else "Mid"
			anim=("Launched_"+mode)
		"Fall":
			anim="Fall"
		"Land":
			anim="Landing_Horizontal"
		"Dead":
			anim="Dead"
	if parent.animation_player.current_animation!= anim && current_state in ["Idle","Fall","Land","Launched","Dead"]:
		parent.animation_player.play(anim)


func _exit_state(_new_state,_old_state):
	match _old_state:
		'_':
			pass

func _unhandled_input(event):
		if event.is_action_pressed("E"):
			Engine.time_scale=0.1
		if event.is_action_pressed("Reset"):
			get_tree().reload_current_scene()

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
	var difference_mouse_position:Vector2=parent.global_position-parent.get_global_mouse_position()
	drag_state.length=(difference_mouse_position).length() if difference_mouse_position.x>0 else 0.0
	#rotates the sloth
	rotate_sloth()
	#animates the sloth according to the mouse position
	Animatate_sloth_acording_to_mouse_position(difference_mouse_position)


# it falls under multiple states

func on_mousebutton_released()->void:
	
	# if the sloth is not launched it will calculate the mouse position and send that parameter to
	# caculate trajectory function
	if launch_state.mode==launch_state.not_launched:
		launch_state.mouse_position =parent.global_position-parent.get_global_mouse_position()
		launch_state.local_mouse_position=parent.get_local_mouse_position()
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


# animates the sloth
func Animatate_sloth_acording_to_mouse_position(mouse_position:Vector2)->void:
	# calculates the direction of sloth if the mouse moves forward it will gives true if back false else it will 
	# give null
	calculate_difference(mouse_position)
	# returns dragstate according to the difference 
	if drag_state.difference==1:
		drag_state.backward=false
	elif drag_state.difference==-1:
		drag_state.backward=true
	else:
		drag_state.backward=null
	#if its backwards it will play back or it will play forward else it will stop the animation
	if parent.animation_player.current_animation!=drag_state.anim:
		if drag_state.backward==false:
			parent.animation_player.play("Dragged_"+drag_state.anim)
		elif drag_state.backward==true:
			parent.animation_player.play_backwards("Dragged_"+drag_state.anim)
		else:
			parent.animation_player.stop(false)

# check for dragging and transitions to other animation

	match drag_state.check:
		drag_state.short_check:
			if drag_state.difference==1:
				drag_state.anim="Short"
				drag_state.check="_"
			else:
				parent.animation_player.stop(false)
		drag_state.long_check:
			if drag_state.difference==-1&&drag_state.anim=="Long":
				drag_state.anim="Short"
				drag_state.check="_"
			else:
				parent.animation_player.stop(false)
		"_":
			pass



# calculates the difference and sets the difference sign of mouse position 

func calculate_difference(mouse_position:Vector2)->void:
	drag_state.current_mouse_position=mouse_position
	var difference=int(drag_state.current_mouse_position.x-drag_state.last_mouse_position.x)
	yield(get_tree(),"physics_frame")
	drag_state.last_mouse_position=drag_state.current_mouse_position
	drag_state.difference=sign(difference)


# calls in animation_player(Drag_state) and during launch state too
# short note it is called inside the animation player
# it trrigers after the animation check for the  animation and sets the animation


func on_short_finished()->void:
	if drag_state.difference==-1:
		drag_state.anim="Short"
	elif drag_state.difference==1:
		drag_state.anim="Long"



# it does things after long its being checked with match condition

func on_long_finished()->void:
	if drag_state.anim=="Long"&&drag_state.difference==1:
		drag_state.check=drag_state.long_check



# it does stuffs when it starts check for difference and sets the animation
func on_long_start()->void:
	if current_state in ["Dragged"]:
		if drag_state.difference==-1:
			drag_state.anim="Short"
		elif drag_state.difference==1:
			drag_state.anim="Long"
	if current_state in ["Launched"] && launch_state.launch_anim=="Long":
		launch_state.launch_anim="Short"



# same as long start 
func on_short_start()->void:
	if current_state in ["Dragged","Idle"]:
		if drag_state.anim=="Short"&&(drag_state.difference==-1||drag_state.difference==0):
			drag_state.check=drag_state.short_check


# it works under Launched state 

# calculates the trajectory after itss fires this function is called in player

func calculate_the_trajectory()->void:
	if launch_state.mode==launch_state.launched:
		parent.apply_velocity(launch_state.mouse_position,parent.LaunchVelocity)



func on_landing():
	if parent.mode!=parent.Idle:
		parent.mode=parent.Idle

func on_dead():
	parent.rotation=0.0
	if dead_state.movement:
		parent.LaunchVelocity=lerp(parent.LaunchVelocity,parent.LaunchVelocity-Vector2(10,10),1)
		parent.LaunchVelocity=parent.move_and_slide(parent.LaunchVelocity,Vector2.UP)
	if parent.LaunchVelocity.x<=0:
		parent.LaunchVelocity=Vector2(0,0)
		dead_state.movement=false
func _on_Land_Area_area_entered(area):
	var parent=area.get_parent()
	if parent.is_in_group("Trees"):
		land_state.can_land=true
		parent.call_deferred("when_sloth_enters_the_tree")

func Todo():
	# TODO: Bounce while dieing
	pass

