extends KinematicBody2D



onready var finate_state_machine=get_node("PlayerFSM")
onready var animation_player=get_node("Body/AnimationPlayer")
onready var tween=get_node("Body/Tween")
onready var Anchor=get_node("Anchor_point")
onready var Player_kinematics=get_node("Player_stats/Player_kinematics")
onready var raycast_parent=get_node("Raycast")


func _ready():
	print(Engine.time_scale)
	finate_state_machine.push_state("Idle")





func check_raycast_collision():
	for raycast in raycast_parent.get_children():
		if raycast.is_colliding():
			return true
	return false


func enable_or_disable_raycast(enabled):
	for raycast in raycast_parent.get_children():
		raycast.enabled=enabled


func add_slow_motion():
	
	"""slows down the time and increases the animation_player speed so that the surroundings will slow down and 
	players animation speed will be same"""
	Engine.time_scale=0.1
	animation_player.playback_speed=5

func remove_slow_motion():
	Engine.time_scale=1
	animation_player.playback_speed=1
