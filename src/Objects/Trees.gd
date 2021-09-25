extends Area2D

onready var animation_player=get_node("AnimationPlayer")


func _on_Trees_area_entered(area):
	if area.is_in_group("Cut"):
		animation_player.play("Fall")
