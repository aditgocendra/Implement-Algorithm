extends Node


onready var tile = $TileMap

var coord
var cell

var start_current_node = Vector2(0,0)
var end_current_node

# f = estimate minimum cost
# g = cost from start node to node n
# h = cost from node n to final node 
var f = 0
var g = 0
var h = 0

func _ready():
	cell = tile.get_used_cells_by_id(0)
	
	var array = [["inside", 7]]
	if array.has(["inside", 7]):
		print(true)
	else: print(false)
	


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			coord = event.position
			end_current_node = tile.world_to_map(coord)
			if cell.has(end_current_node):
				start_current_node = tile.world_to_map($Enemy.global_position)
				astar_algoritm(start_current_node, end_current_node, cell)
			else: print(false)
		

func astar_algoritm(start_index, end_index, graph):
	var open_list = []
	var closed_list = []
	
	
	open_list.append([start_index, 0])
	
	while(open_list.size() > 0):
		var current_node = open_list[0]
		var current_index = 0
		
	
		#get neighbours
		var relative_current_nodes = PoolVector2Array([
				Vector2(current_node[0].x + 1, current_node[0].y),
				Vector2(current_node[0].x - 1, current_node[0].y),
				Vector2(current_node[0].x, current_node[0].y + 1),
				Vector2(current_node[0].x, current_node[0].y - 1),
			])
		
		var neighbours = []
		
		# search neighbours and cost g and n for euclidean distance
		for i in range(relative_current_nodes.size()):
			if cell.has(relative_current_nodes[i]):
					# search g --------------------------------------------
					var tmpg =  Vector2(relative_current_nodes[i].x - start_index.x, 
					relative_current_nodes[i].y - start_index.y)
					g = sqrt((tmpg.x * tmpg.x) + (tmpg.y + tmpg.y))
					# end search g -------------------------------------------
					
					# search h -----------------------------------------------
					var tmph = Vector2(relative_current_nodes[i].x - end_index.x, 
					relative_current_nodes[i].y - end_index.y)
					h = sqrt((tmph.x * tmph.x) + (tmph.y + tmph.y)) 
					# end search h --------------------------------------------
					
					# f(n) = g(n) + h(n)
					f = g + h
					
					# change best node if cost relative node < cost current node
					
					
					if f < current_node[0][1]:
						current_node = [relative_current_nodes, f]
						current_index = i
					
					
					neighbours.append([relative_current_nodes[i], f])

		open_list.remove(current_index)
		
		closed_list.append(current_node)
		
		
		for neighbours_node in neighbours:
			for closed_node in closed_list:
				if neighbours_node[0] == closed_node[0]:
					neighbours.erase(neighbours_node)

			for open_node in open_list:
				if neighbours_node[0] == open_node[0]:
					neighbours.erase(neighbours_node)

			open_list.append(neighbours_node)

#		for neighbours_node in neighbours:
#			for closed_node in closed_list:
#				if neighbours_node == closed_list:
#					continue
#

#		for i in range(neighbours.size()):
#			if !closed_list.has(neighbours[i]) and !open_list.has(neighbours[i]):
#				open_list.append(neighbours[i])

			
			
		if current_node[0] == end_index:
			print(closed_list)
			break
		
	






