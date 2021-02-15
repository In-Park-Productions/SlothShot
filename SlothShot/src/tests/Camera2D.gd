extends Camera2D

signal enable_vmargin(enabled)

export (NodePath) var player_state_machine_path 

enum {Idle,Follow,Dead}
var mode=Idle
var speed=10
var collidied_with_area=false

onready var player_state_machine=get_node(player_state_machine_path)
onready var player=player_state_machine.get_parent()
onready var follow_tween = get_node("Follow_tween")
onready var player_out_area=get_node("Area2D")

func _physics_process(delta):
	var player_state=player_state_machine.current_state
	if player_state in ["Idle","Dragged"]:
		mode=Idle
	elif player_state!="Idle" and player_state!="Dead":
		mode=Follow
	if collidied_with_area || player_state in ["Dead"]:
		mode=Dead
	var enabled=true if player_state in ["Launched","Fall"] else false
	emit_signal("enable_vmargin",enabled)
	
	match mode:
		Idle:
			speed=10
		Follow:
			follow_player(player.global_position)
		Dead:
			speed=lerp(speed,0,0.2)
	position.x+=speed*delta


func follow_player(target_position):
	follow_tween.interpolate_property(self,"position",position,target_position,0.1,follow_tween.TRANS_QUAD,follow_tween.EASE_IN_OUT)
	follow_tween.start()

func enable_vmargin(enabled):
	drag_margin_v_enabled=enabled




func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		collidied_with_area=true
