extends Control


func _on_TouchScreenButton_pressed():
	get_parent().queue_free()
	General.stands_panel_activate = false
