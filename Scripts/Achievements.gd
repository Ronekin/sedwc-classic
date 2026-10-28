extends CanvasLayer








func _ready():
	var Completed: int
	
	for i in acs.achievements.size():
		if acs.achievements[i]["completed"]: Completed += 1
	$TextureRect / Label4.text = "Получено достижений (" + str(Completed) + "/" + str(acs.achievements.size()) + ")"







func _on_TouchScreenButton_released():
	General.toGameGeneral()
