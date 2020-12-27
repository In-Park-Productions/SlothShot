extends KinematicBody2D


const speed:float=400.0
const Gravity:float=500.0
const Weight:float=0.4

var previous_mouse_position:Vector2=Vector2()
var drag_vector:Vector2=Vector2() 
var LaunchVelocity:Vector2=Vector2() 
enum{assend,decend}
var mode=assend

onready var body:Node2D=get_node("Body")
onready var animation_player:AnimationPlayer=get_node("Body/AnimationPlayer")
onready var raycasts:Node2D=get_node("Body/Raycast")
onready var tween:Tween=get_node("Body/Tween")
onready var animated_sprite:AnimatedSprite=get_node("Body/AnimatedSprite")




func check_for_collision():
	for raycast in raycasts:
		if raycast.is_colliding():
			return true
	return false



func Fight():
	pass
func Swim():
	pass


func when_launched()->void:
	pass


func calculate_trajectory(Mouse_position:Vector2,air_resistance:float=0.0,facing:float=1.0)->Array:
	var mouse_length=Mouse_position.length()
	mouse_length=clamp(mouse_length,0.0,600)
	var normalized_mouse_position=Mouse_position.normalized()
	var length=mouse_length/1000 if Mouse_position.y>0 else -(mouse_length/1000)
	var angle=Mouse_position.angle()
	var componets={'x':cos(angle),
					'y':sin(angle)+Gravity}
	var time_of_flight=(speed*sin(angle)/float(Gravity+air_resistance)+1)
	var final_speed=[]
	final_speed.append(Vector2(componets['x']*speed*facing*normalized_mouse_position.x,componets['y']*length))
	return [final_speed,time_of_flight]


func apply_velocity(mouse_position:Vector2,Velocity:Vector2)->void:
	var return_array=calculate_trajectory(mouse_position,0.0,sign(mouse_position.x))
	var velocity=return_array[0][0] if return_array[0][0].x>0 else Vector2()
	var time_of_flight=return_array[1]
	if mode==assend:
		LaunchVelocity=velocity
		LaunchVelocity=move_and_slide(LaunchVelocity)
		yield(get_tree().create_timer(time_of_flight),"timeout")
		mode=decend
	elif mode==decend:
		LaunchVelocity.y+=Gravity*get_physics_process_delta_time()
		LaunchVelocity=move_and_slide(LaunchVelocity,Vector2.UP)
