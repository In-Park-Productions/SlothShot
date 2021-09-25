extends KinematicBody2D

const walk_speed=400
const cut_number=3


var current_tree=null

enum states{
	IDLE,
	SEARCH,
	APPROCH,
	CUT
}
var target_vector=Vector2()
var current_state=states.IDLE
var player=null
var search_direction

onready var animation_player=get_node("Body/AnimationPlayer")

"""
action_state : 1:Choose which tree to cut 
		2:cut the tree
		3:check for other tree
"""


func _physics_process(delta):
	animation()
	match current_state:
		states.IDLE:
			var is_player_there =true if player else false
			var player_present_timer=2 if is_player_there else 4
		states.SEARCH:
			target_vector=detect_objects()
		states.APPROCH:
			var direction=global_position.direction_to(target_vector).x
			var velocity=Vector2(walk_speed,0)*direction if global_position.distance_to(target_vector)>70 else Vector2()
			print(global_position.distance_to(target_vector))
			velocity=move_and_slide(velocity)
			if direction!=0:
				$Body.scale.x=-sign(direction)
			if global_position.distance_to(target_vector)<70:
				current_state=states.CUT
		states.CUT:
			if current_tree==null:
				current_state=states.IDLE
func animation():
	var anim
	if current_state in [states.APPROCH,states.SEARCH]:
		anim="Run"
	elif current_state in [states.IDLE]:
		anim="Idle"
	else:
		anim="Cut"
	
	if animation_player.current_animation !=anim:
		animation_player.play(anim)

func _on_Detected_body_entered(body):
	if body.is_in_group("Player"):
		player=body



func _on_Search_Radius_body_exited(body):
	if body.is_in_group("Player"):
		player=null


func detect_objects():
	$Search_Radius/CollisionShape2D.set_deferred("disabled",false)
	var velocity=Vector2(walk_speed*search_direction,0)
	$Body.scale.x=-search_direction
	velocity=move_and_slide(velocity)
	if current_tree:
		current_state=states.APPROCH
		return current_tree.global_position

func _on_Idle_timer_timeout():
	if current_state==states.IDLE:
		current_state=states.SEARCH
		search_direction=choose([-1,1])
		print("Hello")


func _on_Search_Radius_area_entered(area):
	if area.is_in_group("Trees"):
		current_tree=area
		print(current_tree.name)

func choose(arr:Array):
	randomize()
	arr.shuffle()
	return arr.pop_front()


func _on_Search_Radius_area_exited(area):
	if area.is_in_group("Trees"):
		pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name in ["Cut"]:
		current_tree=null
		current_state=states.IDLE
