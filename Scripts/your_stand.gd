extends Label


func _ready():
	text = "Ваш стенд: "
	match General.stand_number:
		0: text += "None"
		1: text += "The World"
		2: text += "Star Platinum"
		3: text += "Gold Experience"
		4: text += "Tusk Act 1"
		5: text += "Tusk Act 2"
		6: text += "Echoes Act 1"
		7: text += "Echoes Act 0"
		8: text += "King Crimson"
		9: text += "Tusk Act 3"
		10: text += "Soft & Wet"
		11: text += "Tusk act 4"
		12: text += "SPTWKKGEECT Act 0"
		13: text += "King Crimson: Dopio"
		14: text += "Shadow The World"
		15: text += "TW:GH"
		16: text += "TW:OVER HEAVEN"
		17: text += "GE:REQUIM"
		_: text += General.stand_index
