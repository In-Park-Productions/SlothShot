extends KinematicBody2D



onready var finate_state_machine=get_node("PlayerFSM")
onready var animation_player=get_node("Body/AnimationPlayer")
onready var tween=get_node("Body/Tween")
onready var Anchor=get_node("Anchor_point")
onready var Player_kinematics=get_node("Player_stats/Player_kinematics")
onready var raycast_parent=get_node("Raycast")


func _ready():
	finate_state_machine.push_state("Idle")





func check_raycast_collision():
	for raycast in raycast_parent.get_children():
		if raycast.is_colliding():
			return true
	return false


func enable_or_disable_raycast(enabled=true):
	for raycast in raycast_parent.get_children():
		raycast.enabled=enabled
