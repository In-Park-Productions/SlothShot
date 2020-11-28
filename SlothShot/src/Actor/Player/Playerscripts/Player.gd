extends Area2D

signal time_flight_instanciated(time_of_flight)
onready var body:Node2D=get_node("Body")
onready var animation_player:AnimationPlayer=get_node("Body/AnimationPlayer")



var i=false
var previous_mouse_position:Vector2=Vector2()
var drag_vector:Vector2=Vector2()
var LaunchVelocity:Vector2=Vector2()

const speed:float=800.0
const Gravity:float=750.0

enum{
	assend,decend
}
var mode=null
func _process(delta):
	print(position)
	if Input.is_action_pressed("Click"):
		previous_mouse_position=Vector2()
		drag_vector=get_local_mouse_position()
		drag_vector=drag_vector.clamped(150)
		drag_vector.y=clamp(drag_vector.y,0.0,150.0)
		var angle=drag_vector.angle()
		body.position=drag_vector


	if Input.is_action_just_released("Click"):
		previous_mouse_position=get_local_mouse_position()
		previous_mouse_position=previous_mouse_position.clamped(150)
		$Body/Tween.interpolate_property(body,"position",body.position,Vector2(0,0),0.15,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Body/Tween.start()
		yield($Body/Tween,"tween_completed")
		mode=assend if abs(previous_mouse_position.x)>0.1&&abs(previous_mouse_position.y)>0.05 else null

	if mode==assend:
		LaunchVelocity=calculate_projectile(self,800,drag_vector,previous_mouse_position,750,calculatefacing(-(get_local_mouse_position().x)),0,delta)
		position+=LaunchVelocity*delta
	elif mode==decend:
		LaunchVelocity+=Vector2(-1,0.1)
		position+=LaunchVelocity*delta


func calculate_projectile(Body,speed:float,drag_vector:Vector2,local_mouse_position:Vector2,Gravity:float,\
		Facing:int,Air_resisitance:float,delta:float)->Vector2:
	#assending
	var final_velocity:Vector2
	var velocity_vector=Vector2()
	var angle=(local_mouse_position).angle()
	var time_of_flight
	time_of_flight=2*(speed*sin(angle)/float(Gravity+Air_resisitance)) 
	drag_vector=drag_vector.normalized()
	var componets={
		"x":cos(angle),
		"y":sin(angle)-Gravity
	}
	velocity_vector=Vector2(componets["x"],componets["y"])
	final_velocity=velocity_vector*Vector2(speed,1)*drag_vector*Facing
	if abs(position.x)!=0 && abs(position.y)!=0:
		print(final_velocity)
		emit_signal("time_flight_instanciated",time_of_flight)
		print(time_of_flight+1)
	local_mouse_position=Vector2()
	return final_velocity
func calculatefacing(mouse_position)->float:
	return sign(mouse_position)


func _on_Player_time_flight_instanciated(time_of_flight):
	yield(get_tree().create_timer(time_of_flight+1),"timeout")
	mode=decend
func calculate_decend_tragetory(Velocity:Vector2,speed:float,air_resisitance:float,\
								Facing:int,delta:float)->void:
	print(Velocity)
