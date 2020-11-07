extends Node2D
export(String) var game_scene


func _on_TextureButton_pressed():
	get_tree().change_scene("res://src/game/game.tscn")
