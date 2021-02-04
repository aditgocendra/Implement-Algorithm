extends Node
class_name JPFMoveDiagonallyIfNoObstacles

var cell = Autoload.cell


func jump(x, y, px, py, end_node):
	var dX = x - px
	var dY = y - py
	
	if !cell.has(Vector2(x, y)):
		return null

	if Vector2(x, y) == end_node.tile_pos:
		return Vector2(x, y)
	
	#diagonal case
	if dX != 0 and dY != 0:
		if jump(x + dX, y, x, y, end_node) or jump(x, y + dY, x, y, end_node):
				return Vector2(x, y)
	else: 
		if dX != 0:
			if cell.has(Vector2(x, y - 1)) and !cell.has(Vector2(x - dX, y - 1)) or cell.has(
						Vector2(x, y + 1)) and !cell.has(Vector2(x - dX, y + 1)):
							return Vector2(x, y)
		elif dY != 0:
			if cell.has(Vector2(x - 1, y)) and !cell.has(Vector2(x - 1, y - dY)) or cell.has(
						Vector2(x + 1, y)) and !cell.has(Vector2(x + 1, y - dY)):
							return Vector2(x, y)
	
	if cell.has(Vector2(x + dX, y)) and cell.has(Vector2(x, y + dY)):
		return jump(x + dX, y + dY, x, y, end_node)
	else : return null
	
	
func find_neighbours(node):
	var parent = node.parent
	var x = node.tile_pos.x 
	var y = node.tile_pos.y
	var px
	var py
	var nx
	var ny 
	var dx
	var dy
	
	var neighbours = []
	
	if parent:
		px = parent.tile_pos.x
		py = parent.tile_pos.y
		
		dx = (x - px) / max(abs(x - px), 1)
		dy = (y - py) / max(abs(y - py), 1)
		
		if dx != 0 and dy != 0:
			if cell.has(Vector2(x, y + dy)):
				neighbours.append(Vector2(x, y + dy))
			
			if cell.has(Vector2(x + dx, y)):
				neighbours.append(Vector2(x + dx, y))
			
			if cell.has(Vector2(x, y + dy)) and cell.has(Vector2(x + dx, y)):
				neighbours.append(Vector2(x + dx, y + dy))
		else:
			var isNextWalkable
			if dx != 0:
				isNextWalkable = cell.has(Vector2(x + dx, y))
				var isTopWalkable = cell.has(Vector2(x, y + 1))
				var isBottomWalkable = cell.has(Vector2(x, y - 1))
				
				if isNextWalkable:
					neighbours.append(Vector2(x + dx, y))
					
					if isTopWalkable:
						neighbours.append(Vector2(x + dx, y + 1))
					
					if isBottomWalkable:
						neighbours.append(Vector2(x + dx, y - 1))
				
				if isTopWalkable:
					neighbours.append(Vector2(x, y + 1))
				
				if isBottomWalkable:
					neighbours.append(Vector2(x, y - 1))
					
			elif dy != 0:
				isNextWalkable = cell.has(Vector2(x, y + dy))
				var isRightWalkable = cell.has(Vector2(x + 1, y))
				var isleftWalkable = cell.has(Vector2(x - 1, y))
				
				if isNextWalkable:
					neighbours.append(Vector2(x, y + dy))
					
					if isRightWalkable:
						neighbours.append(Vector2(x + 1, y + dy))
					
					if isleftWalkable:
						neighbours.append(Vector2(x - 1, y + dy))
				
				if isRightWalkable:
					neighbours.append(Vector2(x + 1, y))
				
				if isleftWalkable:
					neighbours.append(Vector2(x - 1, y))
						
	else:
		var neighNode = Autoload.get_neighbours(node)
		
		for itr_neigh in neighNode:
			neighbours.append(itr_neigh)
		
	return neighbours
