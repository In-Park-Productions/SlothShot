extends Node2D



func _physics_process(delta):
	pass






func _unhandled_input(event):
	if event.is_action_pressed("Reset"):
			get_tree().reload_current_scene()
	if event.is_action_pressed("E"):
		Engine.time_scale=5

func on_player_dead():
	yield(get_tree().create_timer(0.5),"timeout")
	get_tree().reload_current_scene()


