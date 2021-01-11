extends Node2D

onready var land_area_collision=get_node("Landarea/CollisionShape2D")


func when_sloth_enters_the_tree():
	land_area_collision.disabled=true

