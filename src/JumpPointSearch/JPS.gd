extends Node
class_name JPS

var cell
onready var tile = $TileMap

var open_list
var closed_list
var utils 
var JPF

var time_before = 0
var memory_before = 0

func _ready():
	cell = tile.get_used_cells_by_id(0)
	Autoload.cell = cell
#	print(cell)
	utils = Utility.new()
	JPF = JPFinder.new()
	



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
				find_path(start_pos, end_pos)
			else:print(false)


		
func find_path(start, end):
	open_list = []
	closed_list = []
	#init node start and end node----
	var start_node = JumpNode.new()
	var end_node = JumpNode.new()
	start_node.tile_pos = start
	end_node.tile_pos = end
	
	start_node.gy = 0
	end_node.fy = 0
	#--------------------------------
	
	open_list.append(start_node)
	
	var current_node
	
	while (open_list.size() > 0):
		current_node = open_list.pop_front()
		closed_list.append(current_node)
		
		if current_node.tile_pos == end_node.tile_pos:
			var path = utils.expandPath(utils.backtrace(current_node))
#			print("Elapsed time: %dms"%(OS.get_ticks_msec() - time_before))
#			print(path)
			return path
		identify_succresors(current_node, start_node, end_node)
	
	print("not found")


func identify_succresors(current, start_node, end_node):
	
	var neighbours = JPF.find_neighbours(current)
#	var successor = []
#	print("Neighbours :" , neighbours)
	for index_neighbour in neighbours:
		var jumpPoint = JPF.jump(
			index_neighbour.x, index_neighbour.y, current.tile_pos.x, current.tile_pos.y, end_node)
#		print("JumpPoint : ", jumpPoint)
		if jumpPoint:
			var jx = jumpPoint.x
			var jy = jumpPoint.y
			
			var jumpNode = JumpNode.new()
			jumpNode.tile_pos = Vector2(jx, jy) 
			
			# check jump node in closed list
			var closed = false
			for close in closed_list:
				if close.tile_pos == jumpNode.tile_pos:
					closed = true
					break
			
			if closed:
				continue
			#------------------------------------------------------
			
			var d = utils.manhattan(abs(jx - current.tile_pos.x), abs(jy - current.tile_pos.y))
			var ng  = current.gy + d
			
			# check jump node in open list
			var opened = false
			
			for open in open_list:
				if open.tile_pos == jumpNode.tile_pos:
					opened = true
					break
			#----------------------------------------------------
			
			if !opened or ng < jumpNode.gy:
#				print("Open ", opened ," Distance ", ng , " ", jg)
				jumpNode.gy = ng
				jumpNode.hy = jumpNode.hy or abs(jx - end_node.tile_pos.x) + abs(jy - end_node.tile_pos.y)
				jumpNode.fy = jumpNode.gy + jumpNode.hy
				jumpNode.parent = current
				if !opened:
					open_list.append(jumpNode)
				else:
					open_list = []
					open_list.append(jumpNode)



