extends Node


var cell


func get_neighbours(node):
	var neighbours = []
	
	var relative_nodes = PoolVector2Array([
			Vector2(node.tile_pos.x + 1, node.tile_pos.y), #right
			Vector2(node.tile_pos.x - 1, node.tile_pos.y), #left
			Vector2(node.tile_pos.x, node.tile_pos.y + 1), #bottom
			Vector2(node.tile_pos.x, node.tile_pos.y - 1) #up
#			Vector2(node.tile_pos.x + 1, node.tile_pos.y + 1), #right bottom
#			Vector2(node.tile_pos.x - 1, node.tile_pos.y - 1), #left up
#			Vector2(node.tile_pos.x - 1, node.tile_pos.y + 1), #left bottom
#			Vector2(node.tile_pos.x + 1, node.tile_pos.y - 1) # right up
		])
		
	for relative in relative_nodes:
		if cell.has(relative):
			neighbours.append(relative)
		
	return neighbours
