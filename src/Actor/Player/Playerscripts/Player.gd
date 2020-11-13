extends KinematicBody2D

enum{
	Idle,
	Dragged,
	Launched,
	Fall,
	Holding_branch
}
 
#logic things may be
var state=Fall
var impulse=null
var holding=false
var maximum_jump_velocity

#kinematic things
var gravity
var maximum_jump_height=250
var time=0.5
var launch_velocity


#VectorStuffs
var velocity=Vector2()
var threshold_vector=Vector2()


#cast Nodes
onready var holding_branch=get_node("Branch_Detector")
onready var Body=get_node("Body") 

func _ready():
	#s=ut+1/2a(t^2) u->0
	gravity=(2*(maximum_jump_height)/pow(0.5,2))
	#v^2-u^=2as
	maximum_jump_velocity=-sqrt(2*gravity*maximum_jump_height/8)
	holding_branch.connect("area_entered",self,"check_for_holding")
func _physics_process(delta:float)->void:
	print(velocity)
	if Input.is_action_just_released("click"):
		print("byeeee")
		state=Launched 
	if holding==false&& state!=Dragged:
		velocity.y+=10
	velocity=move_and_slide(velocity)
	match state:
		Idle:
			pass
		Dragged:
			velocity.y=0
			threshold_vector=get_global_position()-get_global_mouse_position()
			threshold_vector=threshold_vector.normalized()
		Launched:
			velocity=(maximum_jump_velocity*threshold_vector)*-1.25
			threshold_vector.y+=0.01
			if threshold_vector.y>=0:
				state=Fall
		Fall:
			velocity.y+=gravity*delta
		Holding_branch:
			velocity=Vector2()
func handle_input():
	pass

func Holding_branch():
	pass
func check_for_holding(area:Area2D):
	print("hi")
	holding=true
	state=Holding_branch


func add_force(velocity:Vector2,Time:float):
	pass


func _on_Player_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		state=Dragged
