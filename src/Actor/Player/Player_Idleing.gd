 extends Node2D


export(NodePath) var player_path
onready var player=get_node(player_path)

onready var raycast_parent=player.get_node("Raycast")

