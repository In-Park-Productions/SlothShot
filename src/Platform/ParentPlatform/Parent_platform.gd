extends Node2D

 
signal entered

export var slope_area_enabled=false
var entered=false
var player=null
onready var area_collisionshape=get_node("exit area/Area2D/CollisionShape2D")
onready var end_point=get_node("endpoint")
onready var area_2d_node=get_node("area_2d")

func _ready():
	
	
	if !slope_area_enabled:
		for children in area_2d_node.get_children():
			children.monitoring=false
			children.monitorable=false
	
	
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


