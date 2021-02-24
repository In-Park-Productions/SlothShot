extends Node2D

func _ready():
	for i in $TileMap.tile_set.get_tiles_ids():
		print(i)
		print($TileMap.tile_set.tile_get_name(i))
