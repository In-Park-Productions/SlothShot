extends Node2D
onready var transiton:Node2D=get_node("Tranisition")
export(String) var game_scene

func StartButton_Pressed():
	get_tree().change_scene("res://src/game/game.tscn")

func QuitButton_Pressed():
	get_tree().quit()

func TestSceneButton_Pressed():
	get_tree().change_scene("res://src/tests/Test.tscn")


func TestButton_Pressed():
	pass # Replace with function body.
