extends "res://src/Statemachine/mainFsm.gd"


#state stuff

class drag:
	const tween_sine=Tween.TRANS_SINE
	const EASE_IN_OUT=Tween.EASE_IN_OUT
	var dragging:bool=false
	var anim:String="Short"
	var current_mouse_position:Vector2=Vector2() 
	var last_mouse_position:Vector2=Vector2()
	var diffrence:float=0.0
	enum{short,long}
	var current_mode=short
	enum {short_check,long_check}
	var check
	var backward

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
	current_state=states[1]
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
		drag_state.dragging=true

func check_dragging_released():
	if Input.is_action_just_released("Click"):
		drag_state.dragging=false

func on_mousebutton_pressed():
	parent.previous_mouse_position=Vector2()
	var diffrence_mouse_poisiton:Vector2=parent.global_position-parent.get_global_mouse_position()
	parent.drag_vector=diffrence_mouse_poisiton
	parent.drag_vector=parent.drag_vector.clamped(100)
	rotate_sloth()
	Animatate_sloth_acording_to_mouse_position(diffrence_mouse_poisiton)

func on_mousebutton_released():
	parent.previous_mouse_position=parent.get_local_mouse_position()
	parent.previous_mouse_position=parent.previous_mouse_position.clamped(100)

func rotate_sloth():
	var temp=parent.global_position-parent.get_global_mouse_position()
	var rotation=(temp).angle() if temp.x>0 else parent.rotation
	var tween = Tween.new()
	parent.add_child(tween)
	tween.interpolate_property(parent,"rotation",parent.rotation,rotation,0.1,drag_state.tween_sine,drag_state.EASE_IN_OUT)
	tween.start()

func Todo():
	#TODO:Complete player animation
	pass

func Animatate_sloth_acording_to_mouse_position(mouse_position:Vector2)->void:
	drag_state.diffrence=calculate_facing(parent.get_local_mouse_position())
	
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


func calculate_facing(mouse_position:Vector2)->float:
	drag_state.current_mouse_position=mouse_position
	var diffrence=int(drag_state.current_mouse_position.x-drag_state.last_mouse_position.x)
	drag_state.last_mouse_position=drag_state.current_mouse_position
	return sign(-diffrence)


#calls in animation_player(Drag_state)
func on_short_finished():
	if drag_state.diffrence==1:
		drag_state.anim="Long"
	else:
		drag_state.anim="Short"

func on_long_finished():
	if drag_state.anim=="Long"&&drag_state.diffrence==1:
		drag_state.check=drag_state.long_check

func on_long_start():
	if drag_state.diffrence==-1:
		drag_state.backward=true
		drag_state.anim="Short"
	else:
		drag_state.anim="Long"
		drag_state.backward=false

func on_short_start():
	if drag_state.anim=="Short"&&(drag_state.diffrence==-1 || drag_state.diffrence==0):
		drag_state.check=drag_state.short
