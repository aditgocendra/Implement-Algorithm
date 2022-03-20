extends Node2D



var end_point = Vector2(0,0)

var multi : PoolVector2Array = [Vector2(0,0), Vector2(300, 300), Vector2(300, 800)]

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			end_point = event.position
			update()
			



func _draw():
#	draw_line(Vector2(0,0), end_point, Color.blue, 1.0)
	for i in range(multi.size()):
		if i + 1 < multi.size():
			draw_line(multi[i], multi[i + 1], Color.blue)
