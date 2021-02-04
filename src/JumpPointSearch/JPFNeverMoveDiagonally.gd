extends Node
class_name JPFNeverMoveDiagonally
var cell = Autoload.cell

func jump(x, y, px, py, end_node):

	var dX = x - px
	var dY = y - py
	
	if !cell.has(Vector2(x, y)):
		return null

	if Vector2(x, y) == end_node.tile_pos:
		return Vector2(x, y)
	
	#diagonal case
	if dX != 0 :
		if cell.has(Vector2(x, y - 1)) and !cell.has(Vector2(x - dX, y - 1)) or cell.has(
					Vector2(x, y + 1)) and !cell.has(Vector2(x - dX,y + 1)):                                         
					return Vector2(x, y)
	elif dY != 0:
		if cell.has(Vector2(x - 1, y)) and !cell.has(Vector2(x - 1, y - dY)) or cell.has(
					Vector2(x + 1, y)) and !cell.has(Vector2(x + 1, y - dY)):  
					return Vector2(x, y)
		if jump(x + 1, y, x, y, end_node) or jump(x - 1, y, x, y, end_node):
				return Vector2(x, y)
	else: return null
	
	return jump(x + dX, y + dY, x, y, end_node)


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
		
		if dx != 0:
			if cell.has(Vector2(x, y - 1)):
				neighbours.append(Vector2(x, y - 1))
			
			if cell.has(Vector2(x, y + 1)):
				neighbours.append(Vector2(x , y + 1))
			
			if cell.has(Vector2(x + dx, y)):
				neighbours.append(Vector2(x + dx, y))
				
		elif dy != 0:
			if cell.has(Vector2(x - 1, y)):
				neighbours.append(Vector2(x - 1, y))
			if cell.has(Vector2(x + 1, y)):
				neighbours.append(Vector2(x + 1, y))
				
			if cell.has(Vector2(x, y + dy)):
				neighbours.append(Vector2(x, y + dy))
	else:
		var neighNode = Autoload.get_neighbours(node)
		
		for itr_neigh in neighNode:
			neighbours.append(itr_neigh)
		
	return neighbours
