extends Node2D

class_name State

onready var actor=get_parent().get_parent()
onready var fsm=get_parent()
onready var player_stats=actor.get_node("Player_stats")
var stats=[]
var current_play=true


func _ready():
	for stat in player_stats.get_children():
		stats.append(stat)



func play_current_state(delta):
	pass

func check_exit_condition(delta):
	pass

func check_previous_state_condition(previous_state):
	pass

func play_current_animation():
	pass
