extends KinematicBody2D



onready var finate_state_machine=get_node("PlayerFSM")
onready var animation_player=get_node("Body/AnimationPlayer")
onready var tween=get_node("Body/Tween")
onready var Anchor=get_node("Anchor_point")
onready var Player_kinematics=get_node("Player_stats/Player_kinematics")

var velocity=0
var b=0
func _ready():
	finate_state_machine.push_state("Dragged")

func _input(event):
	var angle=(global_position-get_global_mouse_position()).angle()
	#print(cos(angle),sin(angle))
	if event.is_action_released("Click"):
		Player_kinematics.calculate_velocity(global_position-get_global_mouse_position())

func _physics_process(delta):
	if Player_kinematics.a :
		if Player_kinematics.trajectory==Player_kinematics.mode.assend:
			Player_kinematics.apply_velocity(delta)
		else:
			Player_kinematics.apply_gravity(delta)
	move_and_slide(Player_kinematics.current_velocity)


func determine_velocity():
	pass
