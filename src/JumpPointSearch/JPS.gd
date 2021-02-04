extends Node
class_name JPS

var cell
onready var tile = $TileMap
var open_list
var utils 
var JPF


func _ready():
	cell = tile.get_used_cells_by_id(0)
	Autoload.cell = cell
	utils = Utility.new()
	JPF = JPFNeverMoveDiagonally.new()

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
				print(find_path(start_pos, end_pos))
			else:print(false)


func find_path(start, end):
	open_list = []
	
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
		current_node.closed = true
		
		if current_node.tile_pos == end_node.tile_pos:
			var path = utils.expandPath(utils.backtrace(current_node))
			return path
		identify_succresors(current_node, start_node, end_node)



func identify_succresors(current, start_node, end_node):
	
	var neighbours = JPF.find_neighbours(current)
#	var successor = []
	
	for index_neighbour in neighbours:
		var jumpPoint = JPF.jump(
			index_neighbour.x, index_neighbour.y, current.tile_pos.x, current.tile_pos.y, end_node)
		
		if jumpPoint != null:
			var jx = jumpPoint.x
			var jy = jumpPoint.y

			var jumpNode = JumpNode.new()
			jumpNode.tile_pos = Vector2(jx, jy) 

			if jumpNode.closed:
				continue

			var d = utils.octile(abs(jx - current.tile_pos.x), abs(jy - current.tile_pos.y))

			var ng  = current.gy + d

			if !jumpNode.opened or ng < jumpNode.gy:
				jumpNode.gy = ng
				jumpNode.hy = jumpNode.hy or abs(jx - end_node.tile_pos.x) + abs(jy - end_node.tile_pos.x)
				jumpNode.fy = jumpNode.gy + jumpNode.hy
				jumpNode.parent = current

				if !jumpNode.opened:
					open_list.append(jumpNode)
					jumpNode.opened = true
				else:
					open_list = jumpNode


