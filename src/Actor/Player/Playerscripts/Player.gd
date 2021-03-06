
extends KinematicBody2D

#constants
const speed:float=500.0
const Gravity:float=700.0
const Weight:float=0.4

#determines launch velocity 
var LaunchVelocity:Vector2=Vector2() 
#divided in to 2 modes one body ascends and then other part it descends
enum{ascend,descend,Idle}
var mode=ascend

#cast nodes
onready var body:Node2D=get_node("Body")
#casting for getting animation node
onready var animation_player:AnimationPlayer=get_node("Body/AnimationPlayer")
onready var land_raycasts:Node2D=get_node("Body/Raycast/Land_raycast")




func check_for_collision()->bool:
	for raycast in land_raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func enable_raycast(raycasts=self.land_raycasts,disabled:bool=false)->void:
	for raycast in raycasts.get_children():
		if disabled==false:
			if !raycast.enabled:
				raycast.enabled=true
		else:
			if raycast.enabled:
				raycast.enabled=false

#future functions 
func Fight():
	yield(animation_player,"animation_finished")
	pass
func Swim():
	pass


## small note before continuing I made this thing dependent of length because I want it to increase as distance increases 
##not to increase in one point and decrease
## I tired with global_mouse_position() and local mouse_position() it doesn't work much so I chose to use length as y axis

func calculate_trajectory(Mouse_position:Vector2,air_resistance:float=0.0,facing:float=1.0)->Array:
	#takes mouse position as an argument it takes the length of a point from mouse position with respective to player center (node) 
	#and take x component( I mean the mouseposition) and put that to length//1000 this clearly gives value of y axis
	#value between 0 to 0.6(since I clamped it) and calculates the projectile using the formula
	#takes the length
#	
	var mouse_length=Mouse_position.length()
	mouse_length=clamp(mouse_length,0.0,160)

	#normalising the mouse position gives the direction
	var normalized_mouse_position=Mouse_position.normalized()
	#takes the length if y axis is greater than zero (its below the player) its gonna give negative result
	var length=mouse_length/500 if Mouse_position.y>0 else -(mouse_length/500)
	#gets angle of mouse
	var angle=abs(Mouse_position.angle()) if abs(global_rotation_degrees)>1.0 else 0
	#components of vector for projectile motion
	var components={'x':cos(angle),
					'y':sin(angle)+Gravity}
	#gives time of flight value so that we can create a timer for that and we can apply gravity later
	var time_of_flight=(speed*sin(angle)/float(Gravity+air_resistance))
	var final_velocity=[]
	#appends the array with value of resultant 
	final_velocity.append(Vector2(components['x']*speed*facing*normalized_mouse_position.x,components['y']*length))
	
	#it returns final speed thats a array , time of flight thats float
	return [final_velocity,time_of_flight]


func apply_velocity(mouse_position:Vector2,Velocity:Vector2)->void:
	#I used it because I wanna call it as a single function in state machine script.
	#it gets the value of parameter here mouse position will be declared in state machine and it also determine the 
	#facing of the sloth


	#it calculates the trajectory and has a value as a array
	var return_array:Array=calculate_trajectory(mouse_position,0.0,sign(mouse_position.x))
	#gets the value from physics  and gets final velocity
	var velocity:Vector2=return_array[0][0] if return_array[0][0].x>0 else Vector2()
	#gets time of the flight value from the physics
	var time_of_flight:float=return_array[1]
	#here I made 2 type of mode one ascends it gets the velocity it applies that velocity up to time of flight period
	#after that it descends due to gravity
	if mode==ascend:
		#assigns the velocity to launch velocity
		LaunchVelocity=velocity
		#creates the time and after it finishes it changes to descend mode
		yield(get_tree().create_timer(time_of_flight),"timeout")
		mode=descend


func apply_movements():
	var Collision=move_and_collide(LaunchVelocity*get_physics_process_delta_time())
	return Collision
# player camera 

func dot_product(the_vector):
	var a = Vector2(0,1)
	var b = the_vector
	var dotproduct=a.dot(b)
	return dotproduct
