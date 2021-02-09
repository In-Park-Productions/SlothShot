extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	var move_direction=int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	position.x+=delta*250
