extends Area2D

onready var animation_player=get_node("AnimationPlayer")


func _on_Trees_area_entered(area):
	if area.is_in_group("Cut"):
		var logger=area.get_parent().get_parent()
		if logger.search_direction==-1:
			$Tween.interpolate_property(self,"rotation_degrees",90,0,1)
		elif logger.search_direction==1:
			$Tween.interpolate_property(self,"rotation_degrees",90,180,1)
		$Tween.start()
		$CollisionShape2D.set_deferred("disabled",true)
