extends Node2D
const Y_CORDINATE=600

export(NodePath)var player_path

var array:Array=["platform1","platform2","Platform3","Platform4","Platform5"]
var platform:PackedScene=preload("res://src/Platform/StartPlatform/Start_platform.tscn")
var  last_platform_componets:Array=[]
var ending_position

onready var first_platform=get_node("Platform")
onready var player=get_node(player_path)

func _ready():
	ending_position=(first_platform.end_point.global_position)
	for i in range(0,6):
		spawn_platforms()

func _physics_process(delta):
	var distance:float= (ending_position).distance_to(player.global_position)
	if distance<1500:
		print("hi")
		spawn_platforms()

func spawn_platforms():
	last_platform_componets=spawn_platform(Vector2(ending_position))
	ending_position=(last_platform_componets[0].end_point.global_position)

func spawn_platform(Position:Vector2)->Array:
	var platform_child=platform.instance()
	platform_child.position=Position
	add_child(platform_child)
	return [platform_child,Position]


func take_random_platform(arrays:Array)->String:
	var chance = (randi()%arrays.size())
	var platform_to_spwan=arrays[chance]
	return platform_to_spwan
