extends Control

export var id = 0.0

func _on_TouchScreenButton_pressed():
	if General.panel_help_tutor_enabled == false:
		if General.check_tutorial_array(id) != - 1:
			General.tutorial_text = General.tutorial_array[General.check_tutorial_array(id)]["Text"]
			General.tutorial_id = float(id)
			General.last_scene = "TutorialGeneral"
			Transition.change_scene("res://GeneralGameScenes/TutorialTema.tscn", "Black")
