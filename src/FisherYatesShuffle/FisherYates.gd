extends Node

#Fisher yates shuffle algorithm

var random_number
var card = ['A', 'B','C','D','E','F','G','H']
var temp

func _ready():
	randomize()
	_start()

func _start():
	var current_index = card.size() - 1
	var size_random = card.size() - 1
	
	for i in range(card.size()):
		random_number = randi() % size_random
		
		temp = card[random_number]
		card[random_number] = card[current_index]
		card[current_index] = temp
		
		current_index -= 1
	print(card)




func _on_Button_pressed():
	_start()
