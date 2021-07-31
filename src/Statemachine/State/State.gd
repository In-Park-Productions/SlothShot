extends Node2D

class_name State

onready var actor=get_parent().get_parent()
onready var fsm=get_parent()

func _ready():
	print(actor)


func play_current_state(delta):
	pass

func check_exit_condition(delta):
	pass

func check_previous_state_condition(previous_state):
	pass

func play_current_animation():
	pass
