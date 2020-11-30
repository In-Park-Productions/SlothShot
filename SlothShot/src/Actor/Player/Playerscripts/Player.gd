extends Area2D

signal time_flight_instanciated(time_of_flight)

const speed:float=800.0
const Gravity:float=750.0
const Weight:float=0.2


var i=false
var previous_mouse_position:Vector2=Vector2()
var drag_vector:Vector2=Vector2()
var LaunchVelocity:Vector2=Vector2()

onready var body:Node2D=get_node("Body")
onready var animation_player:AnimationPlayer=get_node("Body/AnimationPlayer")



enum{
	assend,decend
}
var mode=null
func _process(delta):
#WhenInpu is clicked its for testing purpose i will soon change it 
	if Input.is_action_pressed("Click"):
		previous_mouse_position=get_local_mouse_position()
		previous_mouse_position=previous_mouse_position.clamped(80)
		drag_vector=get_local_mouse_position()
		drag_vector=drag_vector.clamped(80)
		drag_vector.y=clamp(drag_vector.y,0.0,80.0)
		body.position=drag_vector


	if Input.is_action_just_released("Click"):
		$Body/Tween.interpolate_property(body,"position",body.position,Vector2(0,0),0.15,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Body/Tween.start()
		yield($Body/Tween,"tween_completed")
		mode=assend 

	if mode==assend:
		LaunchVelocity=calculate_projectile(self,800,drag_vector,previous_mouse_position,750,calculatefacing(-(previous_mouse_position.x)),0,delta)
		position+=LaunchVelocity*delta

	elif mode==decend:
		LaunchVelocity.y=lerp(LaunchVelocity.y,90,Weight)
		position+=LaunchVelocity*delta


func calculate_projectile(Body,speed:float,drag_vector:Vector2,local_mouse_position:Vector2,Gravity:float,\
		Facing:int,Air_resisitance:float,delta:float)->Vector2:
	#assending
	var final_velocity:Vector2
	var velocity_vector=Vector2()
	var angle=(local_mouse_position).angle()
	var time_of_flight
	time_of_flight=2* (speed * sin(angle) / float( Gravity + Air_resisitance)) 
	drag_vector=drag_vector.normalized()
	var componets={
		"x":cos(angle),
		"y":sin(angle)-Gravity
	}
	velocity_vector=Vector2(componets["x"],componets["y"])
	final_velocity.x=lerp(final_velocity.x,speed*Facing*velocity_vector.x*drag_vector.x,Weight)
	final_velocity.y=lerp(final_velocity.y,velocity_vector.y*drag_vector.y,Weight)
	if abs(position.x)!=0 && abs(position.y)!=0:
		emit_signal("time_flight_instanciated",time_of_flight)
	return final_velocity


func calculatefacing(mouse_position)->float:
	return sign(mouse_position)


func _on_Player_time_flight_instanciated(time_of_flight):
	yield(get_tree().create_timer(time_of_flight+1),"timeout")
	mode=decend


func Fight():
	pass
func Swim():
	pass
