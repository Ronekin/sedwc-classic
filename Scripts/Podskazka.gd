extends Node2D

export var type = "enter"



func _process(delta):
	if type == "enter":
		$Sprite / Label.text = "Войти"
	elif type == "buy100k":
		$Sprite / Label.text = "Приобрести за 100к$"
	elif type == "buy500k":
		$Sprite / Label.text = "Приобрести за 500к$"
	elif type == "buy1m":
		$Sprite / Label.text = "Приобрести за 1м$"
	else:
		$Sprite / Label.text = "Error414"





