extends KinematicBody2D


const speed:float=800.0
const Gravity:float=750.0
const Weight:float=0.4

var previous_mouse_position:Vector2=Vector2()
var drag_vector:Vector2=Vector2() 
var LaunchVelocity:Vector2=Vector2() setget set_lauch_velocity

onready var body:Node2D=get_node("Body")
onready var animation_player:AnimationPlayer=get_node("Body/AnimationPlayer")
onready var raycasts:Node2D=get_node("Body/Raycast")
onready var tween:Tween=get_node("Body/Tween")

func calculatefacing(mouse_position)->float:
	return sign(mouse_position)


func _on_Player_time_flight_instanciated(time_of_flight):
	yield(get_tree().create_timer(time_of_flight),"timeout")

func check_for_collision():
	for raycast in raycasts:
		if raycast.is_colliding():
			return true
	return false

func Apply_velocity():
	LaunchVelocity=move_and_slide(LaunchVelocity,Vector2.UP)

func Fight():
	pass
func Swim():
	pass
func set_lauch_velocity(velocity):
	pass


