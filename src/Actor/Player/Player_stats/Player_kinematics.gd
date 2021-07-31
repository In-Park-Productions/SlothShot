extends Node2D

class_name Stats

export(NodePath) var player_path
onready var player=get_node(player_path)

const Speed=600
const gravity=700

var applied_velocity=Vector2()
var current_velocity=Vector2()
var time_of_flight=4
var time_taken=0

var a =false

enum mode{assend,decend}
var trajectory=mode.assend




func determine_time_of_flight_and_inital_velocity(mouse_position):
	""""Takes the angle from the global _position of the player and takes the globalposition 
	from the mouse and with that angle takes the array of tignomentric identites inital velocity is 
	determined by speed*mouse_length"""
	var angle=abs(mouse_position.angle()) if abs(player.rotation_degrees)>1.0 else 0.0
	var tignomentry=[cos(angle),sin(angle)]
	var time=int(Speed*tignomentry[1]/(gravity))
	return[time,tignomentry]
	

func calculate_velocity(mouse_position):
	"""calculates the velocity of the tragectory using mouse position gets the input from the previous function
	and returns the velocity where it emits the timer starts signal and timer reduces te velocity in the 
	rate of gravity*seconds until the time of flight 
	"""
	var mouse_direction=mouse_position.normalized()
	var mouse_length =mouse_position.length()/500 if mouse_position.y>0 else -(mouse_position.length()/500)
	var components = determine_time_of_flight_and_inital_velocity(mouse_position) 
	time_of_flight=components[0]
	applied_velocity.x=Speed*components[1][0]*mouse_direction.x #Equilent to speed*cos(angle)
	applied_velocity.y=(Speed*components[1][1]+gravity)*mouse_length#equilent to Speed*sin(angle)-gravity
	a=true


func apply_velocity(delta):
	current_velocity=applied_velocity
	yield(get_tree().create_timer(time_of_flight),"timeout")
	trajectory=mode.decend
func apply_gravity(delta):
	current_velocity.y+=gravity*delta


func _on_Timer_timeout():
	trajectory=mode.decend
	print("Hi")
	$Timer.stop()
