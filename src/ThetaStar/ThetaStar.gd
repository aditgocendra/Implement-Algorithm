extends Node


onready var tile = $TileMap

var coord
var cell
var block

var start_current_node = Vector2(0,0)
var end_current_node


var open_list 
var closed_list 

var start_node
var end_node

var time_before
var utility

var full_cell

func _ready():
	full_cell = tile.get_used_cells()
	cell = tile.get_used_cells_by_id(0)
	block = tile.get_used_cells_by_id(1)
	print(tile.map_to_world(Vector2(1.5, 1.5)))



func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			coord = event.position
			end_current_node = tile.world_to_map(coord)
			if cell.has(end_current_node):
				start_current_node = tile.world_to_map($Enemy.global_position)
				time_before = OS.get_ticks_msec()
				astar_algoritm(start_current_node, end_current_node)
#				print(OS.get_ticks_msec() - time_before)
			else: print(false)
		


func astar_algoritm(start_index, end_index):
	
	start_node = ThetaNode.new()
	end_node = ThetaNode.new()
	
	open_list = []
	closed_list = []
	
	start_node.tile_pos = start_index
	end_node.tile_pos = end_index
	
	start_node.parent = start_node
	end_node.parent = null
	
	start_node.g = 0 + c(end_index, start_index)
	open_list.append(start_node)

	var current_node
	while(open_list.size() > 0):
		
		current_node = open_list.pop_back()
#		print(current_node.tile_pos, "parent : ", current_node.parent.tile_pos)
#		print("------------")
		if current_node.tile_pos == end_node.tile_pos:
			var path = []
			var current = current_node
			while current.parent.tile_pos != current.tile_pos:
				path.push_front(current.tile_pos)
				current = current.parent
			path.push_front(current.tile_pos)
			
			print(path)
			
#			for close in closed_list:
#				print(close.tile_pos)
			return
			
		closed_list.append(current_node)
		
		#get childern node
		var childern = PoolVector2Array([
				Vector2(current_node.tile_pos.x + 1, current_node.tile_pos.y),
				Vector2(current_node.tile_pos.x - 1, current_node.tile_pos.y),
				Vector2(current_node.tile_pos.x, current_node.tile_pos.y + 1),
				Vector2(current_node.tile_pos.x, current_node.tile_pos.y - 1),
				Vector2(current_node.tile_pos.x + 1, current_node.tile_pos.y + 1),
				Vector2(current_node.tile_pos.x - 1, current_node.tile_pos.y - 1),
				Vector2(current_node.tile_pos.x - 1, current_node.tile_pos.y + 1),
				Vector2(current_node.tile_pos.x + 1, current_node.tile_pos.y - 1)
			])
		#get neighbour
		
		var neighbour = []
	
		for i in range(childern.size()):
			if cell.has(childern[i]):
				var new_node = ThetaNode.new()
				
				new_node.tile_pos = childern[i]
				
				neighbour.append(new_node)
		
		for node_neighbour in neighbour:
			var visited = false
			for close_node in closed_list:
				if close_node.tile_pos == node_neighbour.tile_pos:
					visited = true
			
			
			for open_node in open_list:
				if open_node.tile_pos == node_neighbour.tile_pos:
					visited = true
			
			
			if visited == false:
				node_neighbour.g = INF
				node_neighbour.parent = null
				
				update_vertex(current_node, node_neighbour)
		

func update(current, neighbour):
	if current.g + c(current.tile_pos, neighbour.tile_pos) < neighbour.g:
			neighbour.g = current.g + c(current.tile_pos, neighbour.tile_pos)
			neighbour.parent = current
			var index = 0
			for open_node in open_list:
				if open_node.tile_pos == neighbour.tile_pos:
					open_list.remove(index)
				index += 1
				
			neighbour.h = c(end_node.tile_pos, neighbour.tile_pos)
			# f(n) = g(n) + h(n)
			neighbour.g = neighbour.g + neighbour.h
			open_list.append(neighbour)


func update_vertex(current, neighbour):
	
	if line_of_sight(current, neighbour):
		
		if current.parent.g + c(current.parent.tile_pos, neighbour.tile_pos) < neighbour.g:
			neighbour.g = current.parent.g + c(current.parent.tile_pos, neighbour.tile_pos)
			neighbour.parent = current.parent
			
			var index = 0
			for open_node in open_list:
				if open_node.tile_pos == neighbour.tile_pos:
					open_list.remove(index)
				index += 1
			
			neighbour.h = c(end_node.tile_pos, neighbour.tile_pos)
			# f(n) = g(n) + h(n)
			neighbour.g = neighbour.g + neighbour.h
			open_list.append(neighbour)
	else:
		if current.g + c(current.tile_pos, neighbour.tile_pos) < neighbour.g:
			neighbour.g = current.g + c(current.tile_pos, neighbour.tile_pos)
			neighbour.parent = current
			var index = 0
			for open_node in open_list:
				if open_node.tile_pos == neighbour.tile_pos:
					open_list.remove(index)
				index += 1
				
			neighbour.h = c(end_node.tile_pos, neighbour.tile_pos)
			# f(n) = g(n) + h(n)
			neighbour.g = neighbour.g + neighbour.h
			open_list.append(neighbour)



func line_of_sight(current, neighbour):
	var x0 = current.tile_pos.x 
	var y0 = current.tile_pos.y
	var x1 = neighbour.tile_pos.x
	var y1 = neighbour.tile_pos.y
	
	
	var dy = y1 - y0
	var dx = x1 - x0
	
	var f = 0
	
	var sx = 0
	var sy = 0
	
	
	if dy < 0:
		dy = -dy
		sy = -1
	else: sy = 1
	
	if dx < 0:
		dx = -dx
		sx = -1
	else: sx = 1
	
	
	if dx >= dy:
		while x0 != x1:
			f = f + dy
			if f >= dx:
				
				if isBlocked(Vector2(x0 + ((sx - 1) / 2) , y0 + ((sy - 1) / 2))): 
					return false
				y0 = y0 + sy
				f = f - dx
			
			if f != 0 and isBlocked(Vector2(x0 + ((sx - 1) / 2), y0 + ((sy - 1) / 2))):
				return false
			
			if dy == 0 and isBlocked(Vector2(x0 + ((sx - 1) / 2), y0)) and isBlocked(Vector2(x0 + ((sx - 1) / 2), y0 - 1)):
				return false
			x0 = x0 + sx
			
	else:
		while y0 != y1:
			f = f + dx
			
			
			if f >= dy:
				
				if isBlocked(Vector2(x0 + ((sx - 1) / 2), y0 + ((sy - 1) / 2))):
					return false
				x0 = x0 + sx
				f = f - dy
			if f != 0 and isBlocked(Vector2(x0 + ((sx - 1) / 2), y0 + ((sy - 1) / 2))):
				return false
			
			if dx == 0 and isBlocked(Vector2(x0 , y0 + ((sy - 1) / 2))) and isBlocked(Vector2(x0 - 1 , y0 + ((sy - 1) / 2))):
				return false
			y0 = y0  + sy
			
	return true


func c(parent_s, neighbour_s):
	var dx = abs(neighbour_s.x - parent_s.x)
	var dy = abs(neighbour_s.y - parent_s.y)
	
	return sqrt(dx * dx + dy * dy)


func octile(dx, dy):
	var F = sqrt(2) - 1
	if dx < dy:
		return F * dx + dy
	else: return F * dy + dx


func isBlocked(vector):
	if vector.x < 0 or vector.y < 0:
		return true
	if block.has(vector):
		return true
	


