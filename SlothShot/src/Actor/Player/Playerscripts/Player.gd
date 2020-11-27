extends Area2D

onready var body:Node2D=get_node("Body")
onready var animation_player:AnimationPlayer=get_node("Body/AnimationPlayer")
var drag_vector=Vector2()
func _process(delta):
	if Input.is_action_pressed("Click"):
		drag_vector=get_local_mouse_position()
		drag_vector=drag_vector.clamped(150)
		drag_vector.y=clamp(drag_vector.y,10.0,150.0)
		body.position=drag_vector
	if Input.is_action_just_released("Click"):
		body.position=Vector2(0,0)



func calculate_projectile(player_position:Vector2,mouse_position:Vector2,\
Gravity:float,Airresistance:float,Mass:float=0)->Vector2:
	var velocity_vector=Vector2()
	var angle=(player_position-mouse_position).angle()
	velocity_vector.x=cos(angle)
	velocity_vector.y=sin(angle)-(Airresistance)
	velocity_vector=velocity_vector.normalized()
	var squared_vector=pow(velocity_vector.x,2)+pow(velocity_vector.y,2)
	var vector_maginitude=sqrt(squared_vector)
	return velocity_vector
