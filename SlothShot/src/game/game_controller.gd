extends Node

var initialspeed = 3.0
var speedrate = 0.1
var maxspeed = 10.0
var jaguartimeinterval = 3.0
var eagletimeinterval = 5.0
var foregrounddistinterval = 20.0
var vinedistinterval = 5.0

var isrunning = false
var speed = 0.0
var score = 0.0
var distance = 0.0
var highscore = 0.0

var nextjaguar = 0.0
var nexteagle = 0.0
var nextforeground = 0.0
var nextvine = 0.0

onready var gameoveruiprefab = preload("res://src/game/game_overui.tscn")
onready var gameuiprefab = preload("res://src/game/game_ui.tscn")
onready var gameworldprefab = preload("res://src/game/game_world.tscn")
onready var jaguarprefab = preload("res://src/actors/jaguar.tscn")
onready var eagleprefab = preload("res://src/actors/eagle.tscn")
onready var vineprefab = preload("res://src/actors/vine.tscn")
onready var foregroundprefab = preload("res://src/actors/foreground.tscn")

func _ready():
	var uinode = get_node("./UI")
	uinode.add_child(gameuiprefab)
	var worldnode = get_node("./World")
	worldnode.add_child(gameworldprefab)
	
	var fd = File.new()
	if fd.file_exists("user://high.score"):
		fd.open("user://high.score", File.READ)
		highscore = int(fd.get_as_text())
	else:
		fd.open("user://high.score", File.WRITE)
		fd.store_string("0")
		highscore = 0
	fd.close()	
	
	
func _process(delta):
	if isrunning:
		speed += delta * speedrate
		if speed > maxspeed:
			speed = maxspeed
		distance += delta * speed
		score = distance
		# camera.transform.position = new Vector3(distance, 5f, -10f)
		
		nextjaguar -= delta
		nexteagle -= delta
		
		if nextjaguar < 0:
			nextjaguar = jaguartimeinterval
			# Spawn Jaguar
		if nexteagle < 0:
			nexteagle = eagletimeinterval
			# Spawn Eagle
		if distance > nextforeground:
			nextforeground += foregrounddistinterval
			# Spawn Foreground
		if distance > nextvine:
			nextvine += vinedistinterval
			# Spawn Vine
	else:
		pass
		
func start_game():
	pass
	
func game_over():
	pass
	
func end_game():
	# Do stuff
	
	if score > highscore:
		highscore = score
		var fd = File.new()
		fd.open("user://high.score", File.WRITE)
		fd.store_string(str(highscore))
		fd.close()
	
	pass
	
