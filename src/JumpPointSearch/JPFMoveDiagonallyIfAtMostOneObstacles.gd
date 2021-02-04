extends Node
class_name JPFMoveDiagonallyIfAtMostOneObstacle
var cell = Autoload.cell

func jump(neigh, current, end_node):

	var dX = neigh.x - current.x
	var dY = neigh.y - current.y
	
	if !cell.has(neigh):
		return null

	if current == end_node.tile_pos:
		return neigh
	
	
	#diagonal case
	if dX != 0 && dY != 0:
		if cell.has(
			Vector2(neigh.x + dX, neigh.y + 1)) and !cell.has(
				Vector2(neigh.x, neigh.y + 1)) or cell.has(
					Vector2(neigh.x + dX, neigh.y - dY)) and !cell.has(
						Vector2(neigh.x, neigh.y - 1)):                                         
			return neigh
		if jump(
			Vector2(neigh.x + dX, neigh.y), neigh, end_node) != null or jump(
				Vector2(neigh.x, neigh.y + dY), neigh, end_node) != null:
			return neigh
	else:
		# horizontal case
		if dX != 0:
			if cell.has(
				Vector2(neigh.x + dX, neigh.y + 1)) and !cell.has(
					Vector2(neigh.x, neigh.y + 1)) or cell.has(
						Vector2(neigh.x + dX, neigh.y - 1)) and !cell.has(
							Vector2(neigh.x, neigh.y - 1)):  
				return neigh
		else :
			if cell.has(
				Vector2(neigh.x + 1, neigh.y + dY)) and !cell.has(
					Vector2(neigh.x + 1, neigh.y)) or cell.has(
						Vector2(neigh.x - 1, neigh.y + dY)) and !cell.has(
							Vector2(neigh.x - 1 , neigh.y)):  
				return neigh
	
	if cell.has(Vector2(neigh.x + dX, neigh.y)) or cell.has(Vector2(neigh.x, neigh.y + dY)):
		return jump(Vector2(neigh.x + dX, neigh.y + dY), neigh, end_node)
	else: return null


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
			
			if cell.has(Vector2(x, y + dy)) or cell.has(Vector2(x + dx, y)):
				neighbours.append(Vector2(x + dx, y + dy))
				
			if !cell.has(Vector2(x - dx, y)) and cell.has(Vector2(x, y + dy)):
				neighbours.append(Vector2(x + dx, y - dy))
			if !cell.has(Vector2(x , y - dy)) and cell.has(Vector2(x + dx, y)):
				neighbours.append(Vector2(x + dx, y - dy))
		else:
			var isNextWalkable
			if dx == 0:
				if cell.has(Vector2(x, y + dy)):
					neighbours.append(Vector2(x, y + dy))
					if !cell.has(Vector2(x - 1, y)):
						neighbours.append(Vector2(x + 1, y + dy))
						
					if !cell.has(Vector2(x - 1, y)):
						neighbours.append(Vector2(x - 1, y + dy))
					
			else :
				if cell.has(Vector2(x + dx, y)):
					neighbours.append(Vector2(x + dx, y))
					if !cell.has(Vector2(x, y + 1)):
						neighbours.append(Vector2(x + dx, y + 1))
					if !cell.has(Vector2(x, y - 1)):
						neighbours.append(Vector2(x + dx, y - 1))
	else:
		var neighNode = Autoload.get_neighbours(node)
		
		for itr_neigh in neighNode:
			neighbours.append(itr_neigh)
		
	return neighbours
