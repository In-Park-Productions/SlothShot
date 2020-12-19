extends Node
class_name physics

static func calculate_projectile(Body,speed:float,drag_vector:Vector2,local_mouse_position:Vector2,Gravity:float,\
		Facing:int,Air_resisitance:float,delta:float,Weight:float)->Array:
	#assending
	var final_velocity:Vector2
	var velocity_vector=Vector2()
	var angle=(local_mouse_position).angle()
	var time_of_flight
	time_of_flight=( 2 * (speed * sin(angle) / float( Gravity + Air_resisitance)) + 1 )
	drag_vector=drag_vector.normalized()
	
	
	var componets={
		"x":cos(angle),
		"y":sin(angle)-Gravity
	}
	velocity_vector=Vector2(componets["x"],componets["y"])
	
	final_velocity.x=lerp(final_velocity.x,speed*Facing*velocity_vector.x*drag_vector.x,Weight)
	final_velocity.y=lerp(final_velocity.y,velocity_vector.y*drag_vector.y,Weight)
	
	return [final_velocity,time_of_flight]

#this is the physic of projectile i made 
