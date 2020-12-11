extends Node2D
onready var transiton:Node2D=get_node("Tranisition")
export(String) var game_scene

# NOT WORKING - Cannot retrieve GlobalStream node from GlobalStream.tscn
# onready var GlobalStream = get_node("res://src/music/GlobalStream").get_node("GlobalStream")

func StartButton_Pressed():
	get_tree().change_scene("res://src/game/game.tscn")

func QuitButton_Pressed():
	get_tree().quit()

func TestButton_Pressed():
	get_tree().change_scene("res://src/tests/Test.tscn")

func _ready():
	# VARIABLE GlobalStream NOT DEFINED
#	if !GlobalStream.playing:
#		GlobalStream.stream = load("res://src/music/Marimba Fast -- Loopable.ogg")
#		GlobalStream.play()
	pass
