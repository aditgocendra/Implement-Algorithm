extends Node


onready var tile = $TileMap

var coord
var cell

var start_current_node = Vector2(0,0)
var end_current_node

var time_before


func _ready():
	cell = tile.get_used_cells_by_id(0)
	


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			coord = event.position
			end_current_node = tile.world_to_map(coord)
			if cell.has(end_current_node):
				start_current_node = tile.world_to_map($Enemy.global_position)
				time_before = OS.get_ticks_msec()
				astar_algoritm(start_current_node, end_current_node, cell)
				print(OS.get_ticks_msec() - time_before)
			else: print(false)
		


func astar_algoritm(start_index, end_index, graph):
	
	var start_node = TileNode.new()
	var end_node = TileNode.new()
	
	
	start_node.tile_pos = start_index
	end_node.tile_pos = end_index
	start_node.parent = start_node
	end_node.parent = null
	
	
	var open_list = []
	var closed_list = []
	
	
	open_list.append(start_node)
	
	var current_node
	while(open_list.size() > 0):
		current_node = open_list[0]
		var current_index = 0 
		
		#search best node
		var index = 0
		for index_item in open_list:
			
			if index_item.f < current_node.f:
				current_node = index_item
				current_index = index
			index += 1
		
		
		open_list.remove(current_index)
		closed_list.append(current_node)
		
		
		if current_node.tile_pos == end_node.tile_pos:
			var path = []
			var current = current_node
			while current.parent.tile_pos != current.tile_pos:
				path.push_front(current.tile_pos)
				current = current.parent


			print(path)
#			for closed in closed_list:
#				print(closed.tile_pos)
			break
		
		
		#get childern node
		var childern = PoolVector2Array([
				Vector2(current_node.tile_pos.x + 1, current_node.tile_pos.y),
				Vector2(current_node.tile_pos.x - 1, current_node.tile_pos.y),
				Vector2(current_node.tile_pos.x, current_node.tile_pos.y + 1),
				Vector2(current_node.tile_pos.x, current_node.tile_pos.y - 1),
				Vector2(current_node.tile_pos.x + 1, current_node.tile_pos.y + 1),
				Vector2(current_node.tile_pos.x - 1, current_node.tile_pos.y - 1),
				Vector2(current_node.tile_pos.x - 1, current_node.tile_pos.y + 1),
				Vector2(current_node.tile_pos.x + 1, current_node.tile_pos.y - 1),
			])
		
		#get neighbour
		
		var neighbour = []
	
		for i in range(childern.size()):
			if cell.has(childern[i]):
				var new_node = TileNode.new()
				new_node.tile_pos = childern[i]
				new_node.parent = current_node
				
				neighbour.append(new_node)
		
		
		for node_neighbour in neighbour:
			var visited = false
			for close_node in closed_list:
				if close_node.tile_pos == node_neighbour.tile_pos:
					visited = true
			
			if visited == false:
				node_neighbour.g = current_node.g + 1
				node_neighbour.h = (abs(node_neighbour.tile_pos[0] - end_node.tile_pos[0])) + (abs(node_neighbour.tile_pos[1] - end_node.tile_pos[1]))
				
				# f(n) = g(n) + h(n)
				node_neighbour.f = node_neighbour.g + node_neighbour.h
		
		
			for open_node in open_list:
				if open_node.tile_pos == node_neighbour.tile_pos and node_neighbour.g > open_node.g:
					visited = true
				
					
			
			if visited == false:
				open_list.append(node_neighbour)





