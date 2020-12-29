extends Node

enum {
	Idle
	Ascension
	Decension
}

var state = Idle
export var speed: float


func _ready():
	pass

func _physics_process(delta):
	
