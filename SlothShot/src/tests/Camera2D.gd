extends Camera2D

signal enable_vmargin(enabled)

export (NodePath) var player_state_machine_path 
onready var player_state_machine=get_node(player_state_machine_path)
onready var player=player_state_machine.get_parent()
onready var tween = get_node("Tween")

enum {Idle,Follow,Dead}
var mode=Idle
func _physics_process(delta):
	var player_state=player_state_machine.current_state
	if player_state in ["Idle","Dragged"]:
		mode=Idle
	elif player_state!="Idle" and player_state!="Dead":
		mode=Follow
	var enabled=true if player_state in ["Launched","Fall"] else false
	emit_signal("enable_vmargin",enabled)
	
	match mode:
		Idle:
			position.x+=10*delta
		Follow:
			follow_player(player.global_position)
		Dead:
			pass
func follow_player(target_position):
	tween.interpolate_property(self,"position",position,target_position,0.1,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	tween.start()

func enable_vmargin(enabled):
	drag_margin_v_enabled=enabled


