extends CanvasLayer

func _on_TouchScreenButton_released():
	General.save_save()
	if General.is_tournir == false:
		General.toGameGeneral()
	else:
		Transition.change_scene("res://GeneralGameScenes/TournirSelect.tscn", "Black")
