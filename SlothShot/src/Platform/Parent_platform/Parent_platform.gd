extends Node2D

signal entered

var player=null
var entered=false

onready var visibility_notifier=get_node("VisibilityNotifier2D")
onready var exit_area_collision_shape=get_node("exitarea/CollisionShape2D")
onready var exit_area=get_node("exitarea")

func _ready():
	connect("entered",self,"on_entering")
	set_physics_process(false)



func on_entering():
	set_physics_process(true)
	exit_area_collision_shape.disabled=false

func _physics_process(_delta):
	if player!=null:
		var distance=self.position.direction_to(player.position)
		if distance>=10.0 && visibility_notifier.is_on_screen():
			print("hi")
			queue_free()

func _on_player_entered(body):
	pass # Replace with function body.
