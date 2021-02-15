extends Node2D

export (NodePath) var player_path
export (NodePath) var camera_path

onready var camera=get_node(camera_path)
onready var player=get_node(player_path)



func _physics_process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("Reset"):
			get_tree().reload_current_scene()

func on_player_dead():
	yield(get_tree().create_timer(0.5),"timeout")
	get_tree().reload_current_scene()


