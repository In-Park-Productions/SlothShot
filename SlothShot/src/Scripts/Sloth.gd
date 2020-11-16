extends Node2D

var pressed = false
var mousePosition: Vector2

func _ready():
	set_process_input(true)

func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT:
		pressed = ev.pressed
		mousePosition = ev.position
		

func _physics_process(delta):
	print(mousePosition.x)
