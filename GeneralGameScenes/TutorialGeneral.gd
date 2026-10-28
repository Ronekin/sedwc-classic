extends CanvasLayer

var panel = preload("res://GeneralGameScenes/HeplTutorial.tscn")

func _on_BackButton_pressed():
	Transition.change_scene("res://GeneralGameScenes/GeneralMenu.tscn", "Black")

func _on_HelpButton_pressed():
	if General.panel_help_tutor_enabled == false:
		var panel_inst = panel.instance()
		add_child(panel_inst)
		General.panel_help_tutor_enabled = true

func _on_Control2_panel_closed():
	General.panel_help_tutor_enabled = false
