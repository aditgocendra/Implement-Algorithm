extends Node2D

var cell
onready var tile = $TileMap
onready var enemy = $Enemy

func _ready():
	cell = tile.get_used_cells_by_id(0)
	Autoload.cell = cell
	

func _input(event):
	var coord
	var end_pos
	var start_pos
	if event is InputEventMouseButton:
		if event.is_pressed():
			coord = event.global_position
			end_pos = tile.world_to_map(coord)
			if cell.has(end_pos):
				start_pos = tile.world_to_map($Enemy.global_position)
				print(start_pos)
			else:print(false)
