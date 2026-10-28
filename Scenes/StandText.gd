extends Label

func _physics_process(delta):
	if General.stand_number == 0:
		text = "None"
	elif General.stand_number == 1:
		text = "The World"
	elif General.stand_number == 2:
		text = "Star Platinum"
	elif General.stand_number == 3:
		text = "Gold Experience"
	elif General.stand_number == 4:
		text = "Tusk Act 1"
	elif General.stand_number == 5:
		text = "Tusk Act 2"
	elif General.stand_number == 6:
		text = "Echoes Act 1"
	elif General.stand_number == 7:
		text = "Echoes Act 0"
	elif General.stand_number == 8:
		text = "King Crimson"
	elif General.stand_number == 9:
		text = "Tusk Act 3"
	elif General.stand_number == 10:
		text = "Soft & Wet"
	elif General.stand_number == 11:
		text = "Tusk Act 4"
	elif General.stand_number == 12:
		text = "SPTWS&WECKKGET Act 0"
	elif General.stand_number == 13:
		text = "King Crimson:Dopio"
	elif General.stand_number == 14:
		text = "Shadow The World"
	elif General.stand_number == 15:
		text = "TW:Greatest High"
	elif General.stand_number == 16:
		text = "TW:Over Heaven"
	elif General.stand_number == 17:
		text = "GE:REQUIM"
	elif General.stand_number == 18:
		text = "Silver Chariot:R"
	elif General.stand_number == 20:
		text = "WhiteSnake"
	elif General.stand_number == 22:
		text = "C-moon"
	elif General.stand_number == 23:
		text = "Made in Heaven"
	elif General.stand_number == 24:
		text = "GE:Requim"
	elif General.stand_number == 25:
		text = "D4C"
	elif General.stand_number == 26:
		text = "Wonder of U"
	elif General.stand_number == 27:
		text = "Heirophant Green"
