extends Node
class_name JPFinder
var cell = Autoload.cell

func jump(x, y, px, py, end_node):
	
	#direction
	var dX = x - px
	var dY = y - py
#	print(x, y)
	if !isWalkAble(x, y):
		return null

	if Vector2(x, y) == end_node.tile_pos:
		return Vector2(x, y)
	
	#diagonal
	if dX != 0 and dY != 0:
		if isWalkAble(x - dX, y + dY) and !isWalkAble(x - dX, y) or isWalkAble(x + dX, y - dY) and !isWalkAble(x, y - dY):
			return Vector2(x, y)
		
		if jump(x + dX, y, x, y, end_node) or jump(x, y + dY, x, y, end_node):
			return Vector2(x,y)
	#horizontal
	else:
		if dX != 0:
			if isWalkAble(x + dX, y + 1) and !isWalkAble(x, y + 1) or isWalkAble(x + dX, y - 1) and !isWalkAble(x, y - 1):
				return Vector2(x,y)
				
		else: 
			if isWalkAble(x + 1, y + dY) and !isWalkAble(x + 1, y) or isWalkAble(x - 1, y + dY) and !isWalkAble(x - 1, y):
				return Vector2(x, y)

	return jump(x + dX, y + dY, x, y, end_node)



func find_neighbours(node):
	var parent = node.parent
	var x = node.tile_pos.x 
	var y = node.tile_pos.y
	var px
	var py
#	var nx
#	var ny 
	var dx
	var dy
	
	var neighbours = []
	
	if parent:
		px = parent.tile_pos.x
		py = parent.tile_pos.y
		
		dx = (x - px) / max(abs(x - px), 1)
		dy = (y - py) / max(abs(y - py), 1)
		
		# search diagonal
		if dx != 0 and dy != 0:
			
			if isWalkAble(x, y + dy):
				neighbours.append(Vector2(x, y + dy))
			
			if isWalkAble(x + dx, y):
				neighbours.append(Vector2(x + dx, y))
			
			if isWalkAble(x + dx, y + dy):
				neighbours.append(Vector2(x + dx, y + dy))
				
			if !isWalkAble(x - dx, y):
				neighbours.append(Vector2(x - dx, y + dy))
				
			if !isWalkAble(x, y - dy):
				neighbours.append(Vector2(x + dx, y - dy))
		# search horizontal / vertical
		else :
			
			if dx == 0:
				
				if isWalkAble(x, y + dy):
					neighbours.append(Vector2(x, y + dy))
					
				if !isWalkAble(x + 1, y):
					neighbours.append(Vector2(x + 1, y + dy))
					
				if !isWalkAble(x - 1, y):
					neighbours.append(Vector2(x - 1, y + dy))
					
			else:
				if isWalkAble(x + dx, y):
					neighbours.append(Vector2(x + dx, y))
				
				if !isWalkAble(x, y + 1):
					neighbours.append(Vector2(x + dx, y + 1))
					
				if !isWalkAble(x, y - 1):
					neighbours.append(Vector2(x + dx, y - 1))
					
					
	else:
		var neighNode = Autoload.get_neighbours(node)
		
		for itr_neigh in neighNode:
			neighbours.append(itr_neigh)
		
	return neighbours



func isWalkAble(x, y):
	if cell.has(Vector2(x, y)):
		return true
	else:
		return false
	
