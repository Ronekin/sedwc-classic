extends Control

func _on_TouchScreenButton_released():
	if General.is_tournir == false:
		General.toGameGeneral()
	else:
		Transition.change_scene("res://GeneralGameScenes/TournirSelect.tscn", "Black")

