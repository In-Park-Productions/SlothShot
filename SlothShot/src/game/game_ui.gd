extends Node

var controller
onready var scorelabel = get_node("./ScoreLabel")
onready var highscorelabel = get_node("./HighscoreLabel")

func _process(delta):
	if controller != null:
		scorelabel.text = "Score: " + str(controller.score)
		if controller.score > controller.highscore:
			highscorelabel.text = "Highscore: " + str(controller.score)
		else:
			highscorelabel.text = "Highscore: " + str(controller.highscore)
