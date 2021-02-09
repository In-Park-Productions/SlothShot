extends Node2D

const LENGTH=26*64
 
signal entered


var entered=false
var player=null
onready var area_collisionshape=get_node("exit area/Area2D/CollisionShape2D")
onready var end_point=get_node("endpoint")

func _ready():
	self.connect("entered",self,"trigger_physic_process")
	set_physics_process(false)
func _physics_process(delta):
	var distance = (player.position).distance_to(self.position)
	if distance>2000:
		queue_free()

func _on_Area2D_body_entered(body):
	player=body
	if player!=null:
		emit_signal("entered")




func trigger_physic_process():
	set_physics_process(true)
