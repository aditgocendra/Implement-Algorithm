extends Node
class_name Utility


func backtrace(current_node):
	var path = [current_node.tile_pos]
	var current = current_node
	
	while current.parent != null:
		current = current.parent
		
		path.push_front(current.tile_pos)
	print(path)
	return path


func interpolate(x0, y0, x1, y1):
	var line = []
	var sx
	var sy
	var dx
	var dy
	var err
	var e2
	
	dx = abs(x1 - x0)
	dy = abs(y1 - y0)
	

	sx = 1 if x0 < x1 else -1
	sy = 1 if y0 < y1 else -1
	
	err = dx - dy
	
	while true:
		line.append(Vector2(x0, y0))
		
		if x0 == x1 and y0 == y1:
			break
			
		e2 = 2 * err
		if e2 > -dy:
			err = err - dy
			x0 = x0 + sx
			
		if e2 < dx:
			err = err + dx
			y0 = y0 + sy
			
	return line
		
func expandPath(path : Array):
	var expanded = []
	var length = path.size()
	var coord1
	var coord2
	var interpolated
	var interpolatedLen
	
	
#	if length < 2:
#		return expanded
		
	for i in range(length - 1):
		coord1 = path[i]
		coord2 = path[i + 1]
		interpolated = interpolate(coord1[0], coord1[1], coord2[0], coord2[1])
		interpolatedLen = interpolated.size()
		for j in range(interpolatedLen - 1):
			expanded.append(interpolated[j])
		
	expanded.append(path[length - 1])
	return expanded



func octile(dx, dy):
	var F = sqrt(2) - 1
	if dx < dy:
		return F * dx + dy
	else: return F * dy + dx


func manhattan(dx, dy):
	return dx + dy

func diagonal_distance(dx, dy):
	var H = 1 * max(dx, dy) + (sqrt(2) - 2 * 1) * min(dx, dy)
	return H
