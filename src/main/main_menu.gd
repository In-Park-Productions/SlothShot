extends Node2D
onready var transiton:Node2D=get_node("Tranisition")
export(String) var game_scene


func _on_TextureButton_pressed():
	get_tree().change_scene("res://src/game/game.tscn")
