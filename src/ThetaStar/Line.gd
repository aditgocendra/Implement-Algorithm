extends Node2D


var end_point = Vector2.ZERO

var multi = [Vector2(0,0), Vector2(0,0)]

func _process(_delta):
	update()


func _draw():
	#	draw_line(Vector2(0,0), end_point, Color.blue, 1.0)
	
	for i in range(multi.size()):
		if i + 1 < multi.size():
			draw_line(Vector2(multi[i].x + 16, multi[i].y  + 16), Vector2(multi[i + 1].x  + 16,  multi[i + 1].y  + 16 ), Color.blue, 2.0)
