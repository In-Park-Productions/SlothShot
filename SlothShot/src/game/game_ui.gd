extends Node

var controller
onready var scorelabel = get_node("./ScoreLabel")
onready var highscorelabel = get_node("./HighscoreLabel")

func _ready():
	controller = get_parent().get_parent()

func _process(delta):
	if controller != null:
		scorelabel.text = "Score: " + str(floor(controller.score))
		if controller.score > controller.highscore:
			highscorelabel.text = "Highscore: " + str(floor(controller.score))
		else:
			highscorelabel.text = "Highscore: " + str(floor(controller.highscore))
