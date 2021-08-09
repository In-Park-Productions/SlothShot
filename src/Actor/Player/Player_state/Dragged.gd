extends State

var drag_diffrence=0
var is_being_clicked:bool=false
var play_backwards=false
var current_mouse_position=Vector2()
var previous_mouse_position=Vector2()
var drag_length=0.0
var check=false
var drag_factor=1.0
enum current_state{start,end}
var check_mode="_"
var launched=false


func _ready():
	current_play=false


func play_current_state(delta):
	if is_being_clicked:
		on_mouse_button_pressed()
	on_mouse_button_released()


func check_exit_condition(delta):
	if transition_to_next_stage():
		return "Launched"


func on_mouse_button_pressed():
	var diffrence_mouse_position=actor.global_position-actor.get_global_mouse_position()
	drag_length=(diffrence_mouse_position).length()*drag_factor if diffrence_mouse_position.x>0 else 0.0
	
	rotate_actor(diffrence_mouse_position,diffrence_mouse_position.angle())
	Animate_player_with_mouse_position(diffrence_mouse_position)
	launched=false
func on_mouse_button_released():
	if Input.is_action_just_released("Click"):
		is_being_clicked=false
		current_mouse_position=actor.global_position-actor.get_global_mouse_position()
		var player_kinematics=actor.Player_kinematics
		player_kinematics.calculate_velocity(current_mouse_position,launched)
		#check for the exiting state


func rotate_actor(mouse_position,angle):
	if is_being_clicked:
		if mouse_position.x>20:
			actor.Anchor.rotation=angle
			actor.tween.interpolate_property(actor,"rotation",actor.rotation,actor.Anchor.rotation,0.1,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
			actor.tween.start()

func Animate_player_with_mouse_position(mouse_position):
	calculate_difference(mouse_position)
	if !check:
		if drag_diffrence==1:
			actor.animation_player.play("Dragged")
		elif drag_diffrence==-1:
			actor.animation_player.play_backwards("Dragged")
		elif drag_diffrence==0:
			actor.animation_player.stop(false)
	else:
		var value=1 if check_mode in [current_state.start] else -1
		exceptions(value)
		drag_factor=0.0 if check_mode in [current_state.start] && value==-1 else 1.0


func on_animation_started():
	check=true
	check_mode=current_state.start

func on_animation_finished():
	check=true
	check_mode=current_state.end

func exceptions(value):
	var distance=(actor.Anchor.global_position-get_global_mouse_position()).length()
	if drag_diffrence!=value || check_mode in [current_state.end] && distance>100:
		actor.animation_player.stop(false)
	else:
		check=false
func calculate_difference(mouse_position:Vector2)->void:
	current_mouse_position=mouse_position
	var difference=int(current_mouse_position.x-previous_mouse_position.x)
	yield(get_tree(),"physics_frame")
	previous_mouse_position=current_mouse_position
	drag_diffrence=sign(difference)

func transition_to_next_stage()->bool:
	if !is_being_clicked && drag_length>25.0 :
		return true 
	return false


func _on_Drag_Area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click"):
		is_being_clicked=true
