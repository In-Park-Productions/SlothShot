extends Node

var initialspeed = 3.0
var speedrate = 0.1
var maxspeed = 10.0
var jaguartimeinterval = 3.0
var eagletimeinterval = 5.0
var foregrounddistinterval = 20.0
var vinedistinterval = 5.0

onready var camera = get_node("./Camera2D")
var worldparent

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

onready var GlobalStream = get_node("/root/GlobalStream")

func _ready():
	# Initiate scenes
	
	# TODO: Assign Global Stream stream to appropriate track
	# FIXME: Sprite appears smaller than default sprite size
	GlobalStream.stop()
	var uinode = get_node("./UI")
	uinode.add_child(gameuiprefab.instance())
	var worldnode = get_node("./World")
	worldparent = worldnode.add_child(gameworldprefab.instance())
	
	# Load highscores
	var fd = File.new()
	if fd.file_exists("user://high.score"):
		fd.open("user://high.score", File.READ)
		highscore = int(fd.get_as_text())
	else:
		fd.open("user://high.score", File.WRITE)
		fd.store_string("0")
		highscore = 0
	fd.close()
	
	# Create initial objects
	spawn_foreground(0)
	spawn_foreground(foregrounddistinterval)
	spawn_player()
	spawn_vine(0)
	
	start_game()
	
func _process(delta):
	if isrunning:
		speed += delta * speedrate
		if speed > maxspeed:
			speed = maxspeed
		distance += delta * speed
		score = distance
		camera.position = Vector2(distance, 0)
		
		nextjaguar -= delta
		nexteagle -= delta
		
		if nextjaguar < 0:
			nextjaguar = jaguartimeinterval
			spawn_jaguar(distance)
		if nexteagle < 0:
			nexteagle = eagletimeinterval
			spawn_eagle(distance)
		if distance > nextforeground:
			nextforeground += foregrounddistinterval
			spawn_foreground(distance)
		if distance > nextvine:
			nextvine += vinedistinterval
			spawn_vine(distance)
	else:
		pass
		
func start_game():
	isrunning = true
	
func game_over():
	isrunning = false
	
func end_game():
	get_tree().change_scene("res://src/main/main_menu.tsch")
	
	if score > highscore:
		highscore = score
		var fd = File.new()
		fd.open("user://high.score", File.WRITE)
		fd.store_string(str(highscore))
		fd.close()
	
	pass
	
func spawn_eagle(dist):
	pass
	
func spawn_jaguar(dist):
	pass
	
func spawn_player():
	pass
	
func spawn_vine(dist):
	pass

func spawn_foreground(dist):
	pass
