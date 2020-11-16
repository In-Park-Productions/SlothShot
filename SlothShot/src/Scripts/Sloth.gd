extends Node2D

var pressed = false
var sloth: Node2D
var mousePosition: Vector2

func _ready():
	set_process_input(true)
	sloth = get_parent().get_node("Sloth")
	print(sloth)

func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT:
		pressed = ev.pressed
		mousePosition = ev.position
		sloth.position = mousePosition
		print(str(sloth.position.x) + " " + str(mousePosition.x))

# func _physics_process(delta):	
